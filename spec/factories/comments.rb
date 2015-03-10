FactoryGirl.define do
  factory :comment do
    body 'MyComment'
    association :commentable, factory: :article
    user
  end
end
