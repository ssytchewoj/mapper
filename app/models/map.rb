class Map < ActiveRecord::Base
  has_many :markers, dependent: :destroy

  accepts_nested_attributes_for :markers, :reject_if => lambda { |m| m[:lat].blank? }, :allow_destroy => true
end
