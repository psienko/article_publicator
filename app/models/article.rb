class Article < ActiveRecord::Base
  belongs_to :user
  acts_as_commentable
  
  validates_presence_of :title, :content
end
