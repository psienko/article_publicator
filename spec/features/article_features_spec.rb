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

  scenario 'The user who is not the author can not see the unpublished ' \
           'article and see error alert' do
    log_in_with(user.email, user.password)
    visit article_path(unpublished_article)
    expect_error_alert_with(:unpublished)
  end

  scenario 'The guest can not see the unpublished article, ' \
           'is redirected to sign in page and see error alert' do
    visit article_path(unpublished_article)
    expect_redirect_to_sign_in_form
    expect_error_alert_with(:lack_of_authentication)
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
end

feature 'Signed in user can create and publish the article' do
  let(:user) { create :user }
  let(:valid_params) { { title: 'MyTitle', content: 'MyContent', published: false } }
  let(:valid_params_with_published) do
    {
      title: 'MyTitle',
      content: 'MyContent',
      published: true
    }
  end
  let(:invalid_params) { { title: '', content: 'MyContent', published: false } }

  scenario 'The guest is redirect to sign in page' do
    visit new_article_path
    expect_redirect_to_sign_in_form
    expect_error_alert_with(:lack_of_authentication)
  end

  scenario 'Signed in user can create article with valid params' do
    log_in_with(user.email, user.password)
    visit new_article_path
    fill_form(valid_params)
    expect_success(:created)
  end

  scenario 'Signed in user can publish article with valid params' do
    log_in_with(user.email, user.password)
    visit new_article_path
    fill_form(valid_params_with_published)
    expect_success(:published)
  end

  scenario 'Signed in user see errors when params are invalid' do
    log_in_with(user.email, user.password)
    visit new_article_path
    fill_form(invalid_params)
    expect_error_alert_with(:errors)
  end
end

feature 'The author can update and publish his article' do
  let(:author) { create :user }
  let(:user) { create :user }
  let(:article) { create :article, user: author }
  let(:valid_params) { { title: 'MyTitle', content: 'MyContent', published: false } }
  let(:valid_params_with_published) do
    {
      title: 'MyTitle',
      content: 'MyContent',
      published: true
    }
  end
  let(:invalid_params) { { title: '', content: 'MyContent', published: false } }

  scenario 'The guest is redirect to sign in page' do
    visit edit_article_path(article)
    expect_redirect_to_sign_in_form
    expect_error_alert_with(:lack_of_authentication)
  end

  scenario 'The user who is not the author see alert with access denied' do
    log_in_with(user.email, user.password)
    visit edit_article_path(article)
    expect_error_alert_with(:access_denied)
  end

  scenario 'The author can update article with valid params' do
    log_in_with(author.email, author.password)
    visit edit_article_path(article)
    fill_form(valid_params)
    expect_success(:updated)
  end

  scenario 'The author can publish article with valid params' do
    log_in_with(author.email, author.password)
    visit edit_article_path(article)
    fill_form(valid_params_with_published)
    expect_success(:published)
  end
end

def fill_form(params)
  fill_in 'Title', with: params[:title]
  fill_in 'Content',  with: params[:content]
  click_button 'Save' unless params[:published]
  click_button 'Publish' if params[:published]
end


def expect_redirect_to_sign_in_form
  expect(current_path).to eq(new_user_session_path)
end

def expect_error_alert
  expect(page).to have_css('div.alert.alert-danger')
end

def expect_success_alert
  expect(page).to have_css('div.alert.alert-success')
end

def expect_error_alert_with(type_of_alert)
  expect_error_alert
  case type_of_alert
  when :unpublished
    expect(page).to have_content('Access denied! This article has not been published yet.')
  when :access_denied
    expect(page).to have_content('Access denied!')
  when :lack_of_authentication
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  when :errors
    expect(page).to have_content('Please correct the errors below.')
  end
end

def expect_success(type)
  expect_success_alert
  case type
  when :created
    expect(page).to have_content('The article has been successfully created.')
  when :published
    expect(page).to have_content('Your article has been published.')
  when :updated
    expect(page).to have_content('The article has been successfully updated.')
  end
end
