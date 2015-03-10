class UserDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def fullname
    "#{object.firstname.capitalize} #{object.lastname.capitalize}"
  end

  def avatar_thumb
    image_tag avatar_thumb_path, alt: 'avatar', class: 'img-responsive img-thumbnail img-circle'
  end

  def avatar_thumb_path
    object.avatar_path(:thumb)
  end
 
end
