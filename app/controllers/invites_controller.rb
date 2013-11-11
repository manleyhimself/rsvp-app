class InvitesController < ApplicationController
  before_action :set_invite, only: [:show, :edit, :update, :destroy]

  def index
    @event = Event.find_by(id: params[:event_id])
    @invites = @event.invites
  end

   def create
    @invite = Invite.new(invite_params)
    @event = Event.find_by(id: params[:event_id])
    respond_to do |format|
      if @invite.save
        format.html { redirect_to event_invite_path(@invite.event_id, @invite), notice: 'invite was successfully created.' }
        format.json { render action: 'show', status: :created, location: @invite }
      else
        format.html { render action: 'new' }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @invite = Invite.new(event_id: params[:event_id])
    @event = Event.find(params[:event_id])
  end

  def show
    @event = Event.find(params[:event_id])
  end

  def update
    @event = Event.find_by(id: params[:event_id])
    @invite = Invite.find(params[:id])
    if !params[:invite].include?("rsvp")
      update_helper
    else
      if @invite.verify_ip(request.ip)
        update_helper
      else
        redirect_to event_invite_path(@event, @invite), notice: 'you are not this invitee.'
      end
    end
  end

  def update_helper
  respond_to do |format|
      if @invite.update(invite_params)
        format.html { redirect_to event_invite_path(@event, @invite), notice: 'invite was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @invite = Invite.find(params[:id])
    @event = Event.find(params[:event_id])
  end

  def destroy
    @invite.destroy
    respond_to do |format|
      format.html { redirect_to event_invites_path(params[:event_id]) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invite
      @invite = Invite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invite_params
      params.require(:invite).permit(:name, :event_id, :rsvp)
    end
end


