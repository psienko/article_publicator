require 'rails_helper'

describe CommentDecorator do

  let(:author) { create :user, firstname: 'John', lastname: 'Doe' }
  let(:date) {  DateTime.new(2015, 1, 1, 0, 0, 0, '+0') }
  let(:comment) do
    described_class.new(create :comment, user: author, created_at: date)
  end

  describe '#author' do
    it 'displays autor name and lastname' do
      expect(comment.author).to eq 'John Doe'
    end
  end

  describe '#date' do
    it "displays created at date and time in format: 'dd-mm-yyyy ar hh:mm'" do
      expect(comment.date).to eq('01-01-2015 at 00:00')
    end
  end
end
