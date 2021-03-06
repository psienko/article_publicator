require 'rails_helper'

describe ArticlesController do
  let(:valid_attributes) { { title: 'title', content: 'content', published: true } }
  let(:invalid_attributes) { { title: '' } }
  let(:user) { create :user }


  context 'user is signed in' do
    before do
      sign_in user
      controller.stub(:user_signed_in?).and_return(true)
      controller.stub(:current_user).and_return(user)
      controller.stub(:authenticate_user!).and_return(user)
    end

    describe 'GET new' do
      it "renders the 'new' template" do
        get :new
        response.should render_template('new')
      end

      it 'exposes a new article' do
        get :new
        response.should render_template('new')
        expect(controller.article).to be_a_new(Article)
      end
    end

    describe 'POST create' do
      describe 'with valida params' do
        it 'creates a new Article' do
          expect do
            post :create, article: valid_attributes
          end.to change(Article, :count).by(1)
        end

        it 'redirects to created article' do
          post :create, article: valid_attributes
          expect(response).to redirect_to(Article.last)
        end

        it 'renders success message' do
          post :create, article: valid_attributes
          expected_message = 'The article has been successfully created.'
          expect(controller.flash[:notice]).to eq expected_message
        end
      end

      describe 'with invalid params' do
        it 'exposes a newly created but unsaved article' do
          Article.any_instance.stub(:save).and_return(false)
          post :create, article: invalid_attributes
          expect(controller.article).to be_a_new(Article)
        end

        it "re-renders the 'new' template" do
          Article.any_instance.stub(:save).and_return(false)
          post :create, article: invalid_attributes
          expect(response).to render_template('new')
        end
      end
    end

    context 'the user is the author' do
      let!(:article) { create :article, user: user }

      describe 'GET show' do
        it 'exposes the requested article when the article is unpublished' do
          get :show, id: article.to_param
          expect(controller.article).to eq(article)
        end

        it 'renders show template' do
          get :show, id: article.to_param
          expect(response).to render_template('show')
        end
      end

      describe 'GET edit' do
        it "renders 'edit' template" do
          get :edit, id: article.to_param
          response.should render_template('edit')
        end

        it 'exposes the requested article' do
          get :edit, id: article.to_param
          expect(controller.article).to eq article
        end
      end

      describe 'PUT update' do
        describe 'with valid params' do
          it 'updates the requested article' do
            Article.any_instance.should_receive(:update)
            .with({ 'title' => 'title', 'content' => 'content', 'published' => false })
            put :update, id: article.to_param, article: valid_attributes
          end

          it 'exposes the lastly updated article' do
            put :update, id: article.to_param, article: valid_attributes
            expect(controller.article).to eq(article)
          end

          it 'redirects to the updated article' do
            put :update, id: article.to_param, article: valid_attributes
            expect(response).to redirect_to(article)
          end
        end

        describe 'with invalid params' do
          it 'exposes the article' do
            Article.any_instance.stub(:save).and_return(false)
            put :update, id: article.to_param, article: valid_attributes
            expect(controller.article).to eq(article)
          end

          it "re-renders the 'edit' template" do
            Article.any_instance.stub(:save).and_return(false)
            put :update, id: article.to_param, article: invalid_attributes
            response.should render_template('edit')
          end
        end
      end

      describe 'DELETE destroy' do
        it 'destroys the requested article' do
          expect do
            delete :destroy, id: article.to_param
          end.to change(Article, :count).by(-1)
        end

        it 'redirects to the articles list' do
          delete :destroy, id: article.to_param
          response.should redirect_to(articles_path)
        end

        it 'renders success message' do
          delete :destroy, id: article.to_param
          expected_message = 'The article has been successfully destroyed.'
          expect(controller.flash[:notice]).to eq expected_message
        end
      end
    end

    context 'the user is not the author' do
      let(:article) { create :article }

      describe 'GET show' do
        it 'renders error message when the article is unpublished' do
          get :show, id: article.to_param
          expected_message = 'Access denied! This article has not been published yet.'
          expect(controller.flash[:alert]).to eq expected_message
        end

        it "redirects to 'index' action" do
          get :show, id: article.to_param
          expect(response).to redirect_to(articles_path)
        end
      end

      describe 'GET edit' do
        it 'redirects to show action' do
          get :edit, id: article.to_param
          expect(response).to redirect_to(article)
        end

        it 'renders error message' do
          get :edit, id: article.to_param
          expect(controller.flash[:alert]).to eq 'Access denied!'
        end
      end

      describe 'PUT update' do
        it 'redirects to show action' do
          put :update, id: article.to_param, article: valid_attributes
          expect(response).to redirect_to(article)
        end

        it 'renders error message' do
          put :update, id: article.to_param, article: valid_attributes
          expect(controller.flash[:alert]).to eq 'Access denied!'
        end
      end

      describe 'DELETE destroy' do
        it 'redirects to show action' do
          delete :destroy, id: article.to_param
          expect(response).to redirect_to(article)
        end

        it 'renders error message' do
          delete :destroy, id: article.to_param
          expect(controller.flash[:alert]).to eq 'Access denied!'
        end
      end
    end
  end

  context 'user is not signed in' do
    let(:article) { create :article }

    describe 'GET show' do
      it 'renders error message when the article is unpublished' do
        get :show, id: article.to_param
        expected_message = 'You need to sign in or sign up before continuing.'
        expect(controller.flash[:alert]).to eq expected_message
      end

      it 'redirects to the login page' do
        get :show, id: article.to_param
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe 'GET edit' do
      it 'redirects to sign in page' do
        get :edit, id: article.to_param
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'renders error message' do
        get :edit, id: article.to_param
        expected_message = 'You need to sign in or sign up before continuing.'
        expect(controller.flash[:alert]).to eq expected_message
      end
    end

    describe 'PUT update' do
      it 'redirects to sign in page' do
        put :update, id: article.to_param, article: valid_attributes
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'renders error message' do
        put :update, id: article.to_param, article: valid_attributes
        expected_message = 'You need to sign in or sign up before continuing.'
        expect(controller.flash[:alert]).to eq expected_message
      end
    end

    describe 'DELETE destroy' do
      it 'redirects to sign in page' do
        delete :destroy, id: article.to_param
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'renders error message' do
        delete :destroy, id: article.to_param
        expected_message = 'You need to sign in or sign up before continuing.'
        expect(controller.flash[:alert]).to eq expected_message
      end
    end
  end

  describe 'GET index' do
    it 'expose all published articles' do
      create :article
      article = create :article, published: true
      get :index
      expect(controller.visible_articles).to eq([article])
    end
  end

  describe 'GET show' do
    it 'expose the requested article when the article is published' do
      article = create :article, published: true
      get :show, id: article.to_param
      expect(controller.article).to eq(article)
    end

    it 'renders show template' do
      article = create :article, published: true
      get :show, id: article.to_param
      expect(response).to render_template('show')
    end
  end
end
