class Event < ActiveRecord::Base
  attr_accessible :locality, :country, :date, :title, :tags

  has_and_belongs_to_many :tags

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
