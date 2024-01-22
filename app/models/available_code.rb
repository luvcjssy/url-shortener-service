class AvailableCode < ApplicationRecord
  validates :code, presence: true, uniqueness: true, length: { maximum: 6 }
end
