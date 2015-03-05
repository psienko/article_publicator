require 'rails_helper'

describe ArticleDecorator do

  let(:author) { create :user, firstname: 'John', lastname: 'Doe' }
  let(:user) { build :user }
  let(:content) { (0...201).map { ('a'..'z').to_a[rand(26)] }.join }
  let(:article) do
    described_class.new(create :article, content: content, user: author, published: true)
  end

  context 'user is the author' do

    before do
      sign_in author
    end

    describe '#read_button' do
      it "displays the 'Read' link" do
        expect(article.read_button).to have_selector('a', text: 'Read')
      end
    end

    describe '#edit_button' do
      it "displays the 'Edit' link" do
        expect(article.edit_button).to have_selector('a', text: 'Edit')
      end
    end

    describe '#delete_button' do
      it "displays the 'Delete' link" do
        expect(article.delete_button).to have_selector('a', text: 'Delete')
      end
    end
  end

  context 'user is not the author' do

    before do
      sign_in user
    end

    describe '#read_button' do
      it "displays the 'Read' link" do
        expect(article.read_button).to have_selector('a', text: 'Read')
      end
    end

    describe '#edit_button' do
      it "does not display the 'Edit' link" do
        expect(article.edit_button).to be_nil
      end
    end

    describe '#delete_button' do
      it "does not display the 'Delete' link" do
        expect(article.delete_button).to be_nil
      end
    end
  end

  describe '#author' do
    it 'displays autor name and lastname' do
      expect(article.author).to eq 'John Doe'
    end
  end

  describe '#short_content' do
    it 'displays not mote than 200 characters of content' do
      expect(article.short_content.length).to be <= 200
    end
  end
end
