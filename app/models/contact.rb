# frozen_string_literal: true

class Contact < ApplicationRecord
  include PgSearch::Model

  require 'activerecord-import/base'
  require 'activerecord-import/active_record/adapters/postgresql_adapter'

  has_many :needs, dependent: :destroy
  has_many :uncompleted_needs, -> { uncompleted }, class_name: 'Need'
  has_many :completed_needs, -> { completed }, class_name: 'Need'

  belongs_to :role, foreign_key: 'lead_service_id', optional: true
  belongs_to :imported_item, optional: true

  has_paper_trail

  validates :first_name, presence: true
  validates_date :date_of_birth, allow_nil: true, allow_blank: true

  pg_search_scope :search,
                  against: [:first_name, :surname, :postcode, :nhs_number, :date_of_birth],
                  using: {
                    tsearch: { prefix: true }
                  }

  def name
    [first_name, middle_names, surname].join(' ')
  end

  def support_actions_count
    needs.not_assessments.size
  end

  def support_actions_names
    needs.not_assessments.map(&:category).join(', ')
  end

  def assigned_to
    role.id.to_s if role
  end
end
