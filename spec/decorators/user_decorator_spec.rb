require 'rails_helper'

describe UserDecorator do

  let(:user) do
    described_class.new(create :user, avatar: nil)
  end

  describe '#fullname' do
    it 'displays autor fullname' do
      expect(user.fullname).to eq 'John Doe'
    end
  end

  describe '#avatar_thumb' do
    it 'displays small avatar' do
      img = "<img alt=\"avatar\" class=\"img-responsive img-thumbnail img-circle\" src=\"" +
            ENV['DEFAULT_AVATAR'] +"\" />"
      expect(user.avatar_thumb).to eq(img)
    end
  end

  describe '#avatar_thumb_path' do
    it 'return path for thumb avatar' do
      expect(user.avatar_thumb_path).to eq(ENV['DEFAULT_AVATAR'])
    end
  end
end
