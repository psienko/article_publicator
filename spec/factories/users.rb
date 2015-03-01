# Read about factories at https://github.com/thoughtbot/factory_girl
include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "example#{n}@example.com" }
    firstname 'John'
    lastname 'Doe'
    password 'password'
    password_confirmation 'password'
    avatar do
      Rack::Test::UploadedFile
      .new(File.join(Rails.root, 'spec', 'support', 'images', 'avatars', 'test.gif'))
    end
  end
end
