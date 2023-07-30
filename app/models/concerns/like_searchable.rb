module LikeSearchable
  extend ActiveSupport::Concern

  included do
    scope :search_by_key, lambda do |key, value|
      self.where("#{key} ILIKE ?", "%#{value}%")
    end
  end
end
