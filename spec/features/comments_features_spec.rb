require 'rails_helper'

feature 'All users can see the list of comments' do
  let(:user) { create :user, firstname: 'John', lastname: 'Doe' }
  let(:article) { create :article }
  let(:date) {  DateTime.new(2015, 1, 1, 0, 0, 0, '+0') }
  # .strftime'%d-%m-%Y at %H:%M'

  before do
    @comment = create :comment, user: user
  end
  
  scenario 'A visitor visit the article page and see all comments' do
    visit article_path(article)
    expect_comment(@comment)
  end

  def expect_comment(comment)
    expect(page).to have_css(".comment-#{comment.id}", text: 'MyComment')
    expect(page).to have_css(".comment-#{comment.id}.answered-by", text: 'John Doe')
    expect(page).to have_css(".comment-#{comment.id}.answered-at", text: '01-01-2015 at 00:00')
  end
end

feature 'Signed in users can add a comment' do
  let(:user) { create :user, firstname: 'John', lastname: 'Doe' }
  let(:article) { create :article }
  let(:date) {  DateTime.new(2015, 1, 1, 0, 0, 0, '+0') }
  
  scenario 'Signed in user can see added comment' do
    log_in_with(user.email, user.password)
    visit article_path(article)
    add_comment('MyNewComment')
    expect_comment
  end

  scenario 'A guest can not add comment and is redirect to login page' do
    visit article_path(article)
    add_comment('MyNewComment')
    expect_redirect_to_sign_in_form
  end

  def expect_redirect_to_sign_in_form
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_content('You need to sign in or sign up before continuing.')
  end

  def add_comment(body)
    fill_in 'New comment', with: body
    click_button 'Comment'
  end

  def expect_comment
    new_comment = Comment.find_by_body('MyNewComment')
    expect(page).to have_css(".comment-#{new_comment.id}", text: 'MyNewComment')
  end
end
