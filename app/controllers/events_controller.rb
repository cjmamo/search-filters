class EventsController < ApplicationController

  def index
    @events = Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events }
    end
  end

  def search

    if params[:event].present?
      country = params[:event][:country]
      locality = params[:event][:locality]
    end

    if  params['start_date'] and params['start_date']['start_date(1i)'].present? and params['start_date']['start_date(2i)'].present? and params['start_date']['start_date(3i)'].present?
      start_date = Date.new(params['start_date']['start_date(1i)'].to_i, params['start_date']['start_date(2i)'].to_i, params['start_date']['start_date(3i)'].to_i)
    end

    if  params['end_date'] and params['end_date']['end_date(1i)'].present? and params['end_date']['end_date(2i)'].present? and params['end_date']['end_date(3i)'].present?
      end_date = Date.new(params['end_date']['end_date(1i)'].to_i, params['end_date']['end_date(2i)'].to_i, params['end_date']['end_date(3i)'].to_i)
    end

    tags = params[:tags]

    @results = Event.in_locality(locality).in_country(country).between(start_date, end_date).tagged(tags)

    @event = Event.new
    @tags = Tag.all
    @results ||= []

    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event }
    end
  end

  def new
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end
end
