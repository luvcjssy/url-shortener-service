class ShortenerUrl < ApplicationRecord
  validates :original_url, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true, length: { maximum: 6 }
  validates :expired_at, presence: true
  validate :url_format

  private

  def url_format
    errors.add(:original_url, 'is invalid') unless URI(original_url).is_a?(URI::HTTP) rescue false
  end
end
