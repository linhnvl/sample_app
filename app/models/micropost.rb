class Micropost < ApplicationRecord
  belongs_to :user
  default_scope ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true,
    length: {maximum: Settings.app.micropost_models.content_maximum}
  validate :picture_size
  scope :user_id, ->(id){where "user_id = ?", id}
  scope :find_user_id, (lambda do |following_ids, id|
    (where "user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end)

  private

  # Validates the size of an uploaded picture.
  def picture_size
    return unless picture.size >
                  Settings.app.micropost_models.picture_size.megabytes
    errors.add :picture, t(".picture_size")
  end
end
