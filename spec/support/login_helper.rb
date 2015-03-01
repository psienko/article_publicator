module LoginHelper
  def log_in_with(email, password)
    visit user_session_path
    fill_in "Email",    with: email
    fill_in "Password", with: password
    click_button "Sign in"
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :feature
end