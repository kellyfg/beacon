namespace :needs_status do
  desc 'Update needs.status based on completed_on'
  task update_needs_statuses: :environment do
    Need.where(completed_on: nil).update_all(status: :to_do)
    Need.where.not(completed_on: nil).update_all(status: :complete)
  end
end
