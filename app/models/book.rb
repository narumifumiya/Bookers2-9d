class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :latest, -> {order(created_at: :desc)} #descは降順…作成日が新しい順になる(10,9,8...)
  scope :old, -> {order(created_at: :asc)} #ascは昇順…作成日が古い順になる(1,2,3...)
  scope :star_count, -> {order(star: :desc)} #starが多い順になる

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect"
      Book.where("title LIKE?","#{word}")
    elsif search == "forward"
      Book.where("title LIKE?","#{word}%")
    elsif search == "backward"
      Book.where("title LIKE?","%#{word}")
    else search == "partial"
      Book.where("title LIKE?","%#{word}%")
    end
  end

end
