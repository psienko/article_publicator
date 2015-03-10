class CommentsController < ApplicationController
  before_action :authenticate_user!, only: :create

  respond_to :json

  expose(:article) { Article.find(params[:article_id]) }
  expose(:comments) { article.root_comments }
  expose(:comment) { Comment.build_from( article, current_user.id, comment_params[:body]) }

  def index
    respond_with comments
  end

  def create
    if comment.save
      render json: comment
    else
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
