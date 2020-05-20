# frozen_string_literal: true

class NotesController < ApplicationController
  before_action :set_note, only: %i[show edit update]

  def create
    @need = Need.find(params[:need_id])
    authorize @need, :update?
    params = note_params
    params.merge!(body: 'No details captured') if note_params[:body].blank?
    @need.notes.create!(params.merge(user: current_user))

    redirect_to need_path(@need)
  end

  def update
    authorize @note
    @note.update(note_params)
  end

  private

  def note_params
    params.require(:note).permit(:body, :category)
  end

  def set_note
    @note = Note.find params[:id]
  end
end
