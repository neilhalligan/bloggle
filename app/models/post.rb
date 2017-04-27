class Post < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :photo, PhotoUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :photo_size

private

  def photo_size
    if photo.size > 5.megabytes
      errors.add(:picture, "Picture must be smaller than 5MB")
    end
  end
end

