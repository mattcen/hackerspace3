class Events::TeamsController < ApplicationController
  def index
    @event = Event.find_by(identifier: params[:event_identifier])
    @teams = @event.teams.where(published: true)
  end
end