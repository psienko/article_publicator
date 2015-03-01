require 'rails_helper'

feature 'User can sign in' do
  let(:user) { create :user }
  
  scenario 'with valid information' do
    log_in_with(user.email, user.password)
    expect(page).to have_css('div.alert.alert-success')
    expect(page).to have_content('Signed in successfully.')
  end

  scenario 'with invalid information' do
    log_in_with(nil, nil)
    expect(page).to have_css('div.alert.alert-danger')
    expect(page).to have_content('Invalid email or password.')
  end
end

feature 'User can sign up' do
  let(:user) { build :user }
  scenario 'successfull user create by form' do
    sign_up(user.firstname, user.lastname,
            user.email, user.password, user.password_confirmation)
    expect_created(user, page)
  end

  def sign_up(firstname, lastname, email, password, confirmation)
    visit new_user_registration_path
    fill_in 'Firstname', with: firstname
    fill_in 'Lastname',  with: lastname
    fill_in 'Email',     with: email
    fill_in 'Password',  with: password
    fill_in 'Password confirmation', with: confirmation
    click_button 'Sign up'
  end

  def expect_created(user, page)
    expect(page).to have_css('div.alert.alert-success')
    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(User.find_by_email(user.email)).to be_present
  end
end

feature 'User can see avatar' do
  let(:user_without_avatar) { create :user, avatar: nil }
  let(:user_with_avatar) { create :user }

  scenario 'user see default avatar when avatar is not set' do
    log_in_and_show_avatar_with(user_without_avatar)
    expect_default_avatar
  end

  scenario 'user see personal avatar when avatar is set' do
    log_in_and_show_avatar_with(user_with_avatar)
    expect_personal_avatar
  end

  def log_in_and_show_avatar_with(user)
    log_in_with(user.email, user.password)
    visit edit_user_registration_path
  end

  def expect_default_avatar
    img = find('img')['src']
          .should have_content '/uploads/user/avatar/default_avatar.gif'
    expect(img).to be_present
  end

  def expect_personal_avatar
    user_id = user_with_avatar.id
    avatar_id = user_with_avatar.avatar_identifier
    img = find('img')['src']
          .should have_content "/uploads/user/avatar/#{user_id}/#{avatar_id}"
    expect(img).to be_present
  end
end
