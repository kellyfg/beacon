class Need < ApplicationRecord
  belongs_to :contact, counter_cache: true
  belongs_to :user, optional: true
  has_many :notes, dependent: :destroy

  has_paper_trail

  scope :completed, -> { where.not(completed_on: nil) }
  scope :uncompleted, -> { where(completed_on: nil)  }

  counter_culture :contact,
                  column_name: proc { |model| model.completed_on ? 'completed_needs_count' : 'uncompleted_needs_count' },
                  column_names: {
                    Need.uncompleted => :uncompleted_needs_count,
                    Need.completed => :completed_needs_count
                  }


  validates :name, presence: true

  delegate :name, :is_vulnerable, to: :contact, prefix: true
  delegate :name, to: :user, prefix: true

  def status
    completed_on.present? ? 'Complete' : 'To do'
  end

  def status=(state)
    self.completed_on = if state == 'Complete'
                          DateTime.now
                        else
                          ''
                        end
    save
  end
end
