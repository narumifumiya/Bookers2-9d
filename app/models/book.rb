class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :latest, -> {order(created_at: :desc)} #descは降順…作成日が新しい順になる(10,9,8...)
  scope :old, -> {order(created_at: :asc)} #ascは昇順…作成日が古い順になる(1,2,3...)
  scope :star_count, -> {order(star: :desc)} #starが多い順になる

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def save_tags(sent_tags)
    # タグが存在してるか？確認し、あれば現在bookの持っているタグを引っ張ってきている
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在bookが持っているタグと今回入力されたものの差をすでにあるタグとする。古いタグは消す。
    old_tags = current_tags - sent_tags
    # 今回入力されたものと現在存在するタグの差を新しいタグとする。新しいタグは保存
    new_tags = sent_tags - current_tags

    # 古いタグを消す（要らなくなったタグを削除）
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name:old)
    end

     # 新しいタグを保存
     new_tags.each do |new|
       new_book_tag = Tag.find_or_create_by(name: new)
       # 配列に保存
       self.tags << new_book_tag
     end

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
