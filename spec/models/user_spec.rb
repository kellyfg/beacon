require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:organisation).optional(true) }
    it { is_expected.to have_many(:contact_list_users) }
    it { is_expected.to have_many(:contact_lists).through(:contact_list_users) }
    it { is_expected.to have_many(:contacts).through(:contact_lists) }
    it { is_expected.to have_many(:needs).dependent(:destroy) }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to have_many(:assigned_contacts).through(:needs).source(:contact) }
    it { is_expected.to have_many(:uncompleted_needs).conditions(completed_on: nil) }
    it { is_expected.to have_many(:completed_needs).conditions('completed_on IS NOT NULL') }
    it { is_expected.to have_many(:uncompleted_contacts).through(:uncompleted_needs).source(:contact) }
    it { is_expected.to have_many(:completed_contacts).through(:completed_needs).source(:contact) }
  end

  it { is_expected.to be_versioned }

  it '#name' do
    user = build :user, first_name: 'John', last_name: 'Doe'

    expect(user.name).to eq 'John Doe'
  end
end
