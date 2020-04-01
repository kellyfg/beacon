class Contact < ApplicationRecord
  belongs_to :contact_list, optional: true
  has_many :needs, dependent: :destroy
  has_many :uncompleted_needs, -> { uncompleted }, class_name: 'Need'
  has_many :completed_needs, -> { completed }, class_name: 'Need'

  acts_as_ordered_taggable
  has_paper_trail

  validates :first_name, presence: true

  def name
    [first_name, surname].join(' ')
  end
end
