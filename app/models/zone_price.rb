class ZonePrice < ActiveRecord::Base
  validates_presence_of :price
  validates_numericality_of :price

  belongs_to :zone
  belongs_to :zoneable, :polymorphic => true
end
