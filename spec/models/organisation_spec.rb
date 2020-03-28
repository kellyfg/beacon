require 'rails_helper'

RSpec.describe Organisation, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:users).dependent(:restrict_with_exception) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
  end
end