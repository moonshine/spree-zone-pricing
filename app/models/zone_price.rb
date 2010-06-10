class ZonePrice < ActiveRecord::Base
  belongs_to :zone
  belongs_to :variant

  validates_presence_of :price
  validates_numericality_of :price
  validates_presence_of :variant
  validates_presence_of :zone

end
