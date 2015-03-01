require 'rails_helper'

describe User do
  let(:user_with_avatar) { create :user }
  let(:user_with_out_avatar) { create :user, avatar: nil }

  it { should validate_presence_of :firstname }
  it { should validate_presence_of :lastname }

  describe '#avatar_path' do
    it 'returns avatar url when avatar is set' do
      result = user_with_avatar.avatar_path
      expect(result).to eq(user_with_avatar.avatar.url)
    end

    it 'returns default avatar url when avatar is not set' do
      result = user_with_out_avatar.avatar_path
      expect(result).to eq(ENV['DEFAULT_AVATAR'])
    end
  end
end
