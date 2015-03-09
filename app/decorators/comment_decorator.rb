class CommentDecorator < Draper::Decorator
  delegate_all

  def author
    "#{object.user.firstname.capitalize} #{object.user.lastname.capitalize}" if object.user
  end

  def date
    object.created_at.strftime'%d-%m-%Y at %H:%M'
  end

end
