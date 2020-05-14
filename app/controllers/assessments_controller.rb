class AssessmentsController < ApplicationController
  before_action :set_contact, only: %i[new create edit update]

  def new
    @assigned_to_options = construct_assigned_to_options
    @type = %w[log schedule].include?(type_param) ? type_param : 'log'

    @need = Need.new
    @note = Note.new

    @need.status = 'complete' if @type == 'log'
    @need.user = current_user if @type == 'log'
  end

  def create
    authorize Need
    @type = %w[log schedule].include?(type_param) ? type_param : 'log'
    if @type == 'log'
      log_assessment
    else
      schedule_assessment
    end
  end

  def edit
    @need = Need.find(params[:id])
    @stage = params[:stage] || 'initial'

    if @stage == 'failed'
      render 'failed_assessment'
    elsif @stage == 'complete'
      render 'complete_assessment'
    end
  end

  def update
    assessment = Need.find(params[:id])
    if params['stage'] == 'complete'
      Need.where(status: 'pending', assessment_id: params[:id]).update_all(status: 'to_do')
      assessment.update(status: 'complete')
      redirect_to contact_path(@contact)
    end
  end

  private

  def set_contact
    @contact = Contact.find(params[:contact_id])
  end

  def log_assessment
    @need = Need.new(assessment_params.merge(contact_id: @contact.id, name: 'Logged assessment', start_on: Date.today))
    @note = Note.new(notes_params.merge(need: @need, category: 'phone_success', user_id: current_user.id))
    if @need.valid? && @note.valid? && @need.save && @note.save
      redirect_to contact_path(@contact)
      return
    end

    @assigned_to_options = construct_assigned_to_options
    render :new
  end

  def schedule_assessment
    @need = Need.new(assessment_params.merge(contact_id: @contact.id))
    @note = Note.new
    unless @need.valid?
      @assigned_to_options = construct_assigned_to_options
      render :new
      return
    end

    @need.save
    redirect_to contact_path(@contact)
  end

  def type_param
    params.require(:type)
  end

  def assessment_params
    params.require(:need).permit(:assigned_to, :name, :is_urgent, :status, :category, :status, :start_on)
  end

  def notes_params
    params.require(:note).permit(:body)
  end

  def construct_assigned_to_options
    roles = Role.all.order(:name)
    users = User.all.order(:first_name, :last_name)

    {
      'Teams' => roles.map { |role| [role.name, "role-#{role.id}"] },
      'Users' => users.map { |user| [user.name_or_email, "user-#{user.id}"] }
    }
  end
end
