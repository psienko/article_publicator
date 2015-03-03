class ArticleDecorator < Draper::Decorator
  delegate_all
  include Draper::LazyHelpers

  def read_button(size_class = nil)
      link_to 'Read', article_path(object), class: "btn btn-primary #{size_class}"
  end

  def edit_button(size_class = nil)
    return nil if object.user != current_user
    link_to 'Edit', edit_article_path(object), class: "btn btn-success #{size_class}"
  end

  def delete_button(size_class = nil)
    return nil if object.user != current_user
    link_to 'Delete', article_path(article), class: "btn btn-danger #{size_class}",
      method: :delete, data: { confirm: 'Are you sure?' }
  end

  def author
    "#{object.user.firstname.capitalize} #{object.user.lastname.capitalize}" if object.user
  end

  def short_content
    truncate(object.content, length: 200)
  end
end
