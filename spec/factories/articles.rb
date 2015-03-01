FactoryGirl.define do
  factory :article do
    title 'MyTitle'
    content 'Content'
    published false
    user
  end
end
