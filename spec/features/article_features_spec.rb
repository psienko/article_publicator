require 'rails_helper'

feature 'User can see the article' do
  let(:author) { create :user }
  let(:user) { create :user }
  let(:unpublished_article) { create :article, title: 'MyTitle', content: 'MyContent', user: author }
  let(:published_article) { create :article, title: 'MyTitle', content: 'MyContent', published: true }
 
  scenario 'The author can see the unpublished article' do
    log_in_with(author.email, author.password)
    visit article_path(unpublished_article)
    expect_article_page(unpublished_article)
  end

  scenario 'The user who is not the author can not see the unpublished article' do
    log_in_with(user.email, user.password)
    visit article_path(unpublished_article)
    expect_unpublished_alert
  end

  scenario 'The guest can not see the unpublished article' do
    visit article_path(unpublished_article)
    expect_redirect_to_sign_in_form
    expect_unpublished_alert
  end

  scenario 'The guest can see the published article' do
    visit article_path(published_article)
    expect_article_page(published_article)
  end

  scenario 'Signed in user can see the published article' do
    log_in_with(user.email, user.password)
    visit article_path(published_article)
    expect_article_page(published_article)
  end

  def expect_article_page(article)
    expect(current_path).to eq(article_path(article))
    expect(page).to have_content('MyTitle')
    expect(page).to have_content('MyContent')
  end

  def expect_unpublished_alert
    expect_error_alert
    expect(page).to have_content('Access denied! This article has not been published.')
  end
end

feature 'Signed in user can create the article' do
  let(:user) { create :user }
  let(:valid_params) { { title: 'MyTitle', content: 'MyContent', published: false, user: user } }
  let(:invalid_params) { { title: '', content: 'MyContent', published: false, user: user } }

  scenario 'The guest is redirect to sign in page' do
    visit new_article_path
    expect_redirect_to_sign_in_form
    expect_lack_of_authentication
  end

  scenario 'Signed in user can create article with valid_params' do
    visit new_article_path
    fill_form(valid_params)
    expect_success
  end

  def expect_success
    expect_success_alert
    expect(page).to have_content('The article has been successfully created.')
  end
end

def fill_form(params)
  fill_in 'Title', with: params[:title]
  fill_in 'Content',  with: params[:content]
  click_button 'Save'
end

def expect_access_denied
  expect_error_alert
  expect(page).to have_content('Access denied!')
end

def expect_redirect_to_sign_in_form
  expect(current_path).to eq(new_user_session_path)
end

def expect_lack_of_authentication
  expect_error_alert
  expect(page).to have_content('You need to sign in or sign up before continuing.')
end

def expect_error_alert
  expect(page).to have_css('div.alert.alert-danger')
end

def expect_success_alert
  expect(page).to have_css('div.alert.alert-success')
end
