class UserSerializer < ActiveModel::Serializer
  attributes :id, :firstname, :lastname, :avatar, :email,
             :created_at, :updated_at, :avatar_thumb, :fullname,
             :avatar_thumb_path

  def avatar_thumb
    decorated.avatar_thumb
  end

  def avatar_thumb_path
    decorated.avatar_thumb_path
  end

  def fullname
    decorated.fullname
  end

  def decorated
    @decorated ||= UserDecorator.new(object)
  end
end
