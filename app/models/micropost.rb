class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size

  # Returns microposts from the users being followed by the given user.
  def Micropost.from_users_followed_by(user)
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: user)
  end

  private

    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "should be less than 5MB")
      end
    end
end
