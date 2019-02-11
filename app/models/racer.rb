class Racer
  include ActiveModel::Model

  attr_accessor :id
  attr_accessor :number
  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :gender
  attr_accessor :group
  attr_accessor :secs

  class << self
    def mongo_client
      Mongoid::Clients.default
    end

    def collection
      mongo_client[:racers]
    end

    def all(prototype = {}, sort = {}, skip = 0, limit = nil)
      limit ||= 0
      collection.find(prototype).sort(sort).skip(skip).limit(limit)
    end

    def find(id)
      result = collection.find(_id: BSON::ObjectId.from_string(id)).first
      new(result) if result
    end
  end

  def initialize(params = {})
    self.id = params[:id] || params[:_id].to_s
    self.attributes = params
  end

  def persisted?
    id.present?
  end

  def created_at
  end

  def updated_at
  end

  def attributes=(params)
    self.number = params[:number].to_i if params[:number]
    self.first_name = params[:first_name]
    self.last_name = params[:last_name]
    self.gender = params[:gender]
    self.group = params[:group]
    self.secs = params[:secs].to_i if params[:secs]
  end

  def attributes
    {
      number: number,
      first_name: first_name,
      last_name: last_name,
      gender: gender,
      group: group,
      secs: secs
    }
  end

  def save
    result = self.class.collection.insert_one(attributes)
    self.id = result.inserted_id.to_s
  end

  def update(params)
    self.attributes = params
    self.class.collection.find(_id: BSON::ObjectId.from_string(id)).replace_one(attributes)
  end

  def destroy
    self.class.collection.find(number: number).delete_one
  end
end
