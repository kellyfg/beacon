class ContactsController < ApplicationController
  before_action :require_user!
  before_action :set_contact, only: [:edit, :update, :show, :show_tasks]

  def index
    @contacts = Contact.all.page(params[:page])
  end

  def show_tasks
    @users = User.all
    @task = Task.new
  end

  def show
  end

  def edit
  end

  def update
    if @contact.update(contact_params)
      redirect_to contact_path(@contact), notice: 'Contact was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :middle_names, :surname, :address, :postcode, :email, :telephone, :mobile, :additional_info, :priority)
  end
end
