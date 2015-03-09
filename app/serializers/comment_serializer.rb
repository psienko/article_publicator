class CommentSerializer < ActiveModel::Serializer
  attributes :id, :author, :body, :commentable_id, :commentable_type, :title,
             :subject, :user_id, :parent_id, :lft, :rgt, :created_at,
             :updated_at, :date, :user

  def author
    decorated.author
  end

  def user
    UserSerializer.new(object.user)
  end


  def date
    decorated.date
  end

  def decorated
    @decorated ||= CommentDecorator.new(object)
  end
end
