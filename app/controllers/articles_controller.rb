class ArticlesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_filter :require_author, only: [:edit, :update, :destroy]
  before_filter :require_published, only: :show
  
  expose(:visible_articles) { Article.where(published: true).decorate }
  expose(:article)
  
  def index
  end

  def show
  end

  def new
  end

  def create
    article = Article.new(article_params)
    article.user_id = current_user.id
    article.published = params[:publish] ? true : false
    if article.save
      redirect_to article_path(article)
      flash[:notice] = 'The article has been successfully created.' unless article.published?
      flash[:notice] = 'Your article has been published.' if article.published?
    else
      flash[:alert] = 'Please correct the errors below.'
      render action: 'new'
    end
  end

  def edit
  end

  def update
    update_params = article_params
    update_params[:published] = params[:publish] ? true : false
    if article.update(update_params)
      redirect_to article_path(article)
      flash[:notice] = 'The article has been successfully updated.' unless article.published?
      flash[:notice] = 'Your article has been published.' if article.published?
    else
      flash[:alert] = 'Please correct the errors below.'
      render action: 'edit'
    end
  end

  def destroy
    article.destroy
    redirect_to articles_path, notice: 'The article has been successfully destroyed.'
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :published)
  end

  def require_author
    if current_user != article.user
      redirect_to article_path(article)
      flash[:alert] = 'Access denied!'
    end
  end

  def require_published
    return true if article.published?
    case user_signed_in?
    when true
      flash[:alert] = 'Access denied! This article has not been published yet.'
      redirect_to articles_path
    when false
      flash[:alert] = 'You need to sign in or sign up before continuing.'
      redirect_to new_user_session_path
    end if article.user != current_user
  end
end
