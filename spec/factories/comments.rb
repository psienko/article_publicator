FactoryGirl.define do
  factory :comment do
    body 'MyComment'
    content 'Content'
    association :commentable, factory: :article
    user
  end
end
