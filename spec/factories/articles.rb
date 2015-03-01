FactoryGirl.define do
  factory :article do
    title 'MyString'
    content 'MyText'
    published false
    user
  end
end
