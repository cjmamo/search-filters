class Event < ActiveRecord::Base
  attr_accessible :locality, :country, :date, :title, :tags

  has_and_belongs_to_many :tags

  def self.find(country, locality, start_date, end_date, tags)

    if country.present? and locality.present? and start_date.present? and end_date.present? and tags.present?
      @results = Event.where('country = ? AND locality = ? AND date >= ? AND date <= ?', country, locality, start_date, end_date).joins('LEFT JOIN events_tags ON (events.id = events_tags.event_id) LEFT JOIN tags ON (tags.id = events_tags.tag_id)').where('tags.id' => tags).group('events.id').having("count(events.id) = #{tags.count}")
    elsif country.present? and locality.present? and start_date.present? and end_date.present?
      @results = Event.where('country = ? AND locality = ? AND date >= ? AND date <= ?', country, locality, start_date, end_date)
    elsif country.present? and locality.present? and start_date.present? and end_date.present? and
        @results = Event.where('country = ? AND locality = ? AND date >= ? AND date <= ?', country, locality, start_date, end_date)
    elsif country.present? and locality.present? and start_date.present?
      @results = Event.where('country = ? AND locality = ? AND date >= ?', country, locality, start_date)
    elsif country.present? and locality.present?
      @results = Event.where('country = ? AND locality = ?', country, locality)
    elsif country.present?
      @results = Event.where('country = ?', country)
    elsif start_date.present? and tags.present?
      @results = Event.where('date >= ?', start_date).joins('LEFT JOIN events_tags ON (events.id = events_tags.event_id) LEFT JOIN tags ON (tags.id = events_tags.tag_id)').where('tags.id' => tags).group('events.id').having("count(events.id) = #{tags.count}")
    end

  end

  def self.in_country(country)
    if country.present?
      where('country = (?)', country)
    else
      scoped
    end
  end

  def self.in_locality(locality)
    if locality.present?
      where('locality = (?)', locality)
    else
      scoped
    end
  end

  def self.tagged(tags)
    if tags.present?
      joins('LEFT JOIN events_tags ON (events.id = events_tags.event_id) LEFT JOIN tags ON (tags.id = events_tags.tag_id)').where('tags.label' => tags).group('events.id').having("count(events.id) = #{tags.count}")
    else
      scoped
    end
  end

  def self.between(start_date, end_date)
    if start_date.present? and end_date.present?
      where('date >= ? AND date <= ?', start_date, end_date)
    elsif start_date.present?
      where('date = ?', start_date)
    else
      scoped
    end
  end

end
