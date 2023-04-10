class Tag < ApplicationRecord
  has_many :book_tags, dependent: :destroy, foreign_key: 'tag_id'
  has_many :books, through: :book_tags

  def self.looks(search, word)
    if search == "perfect"
      tags = Tag.where("name Like?","#{word}")
    elsif search == "forward"
      tags = Tag.where("name Like?","#{word}%")
    elsif search == "backward"
      tags = Tag.where("name Like?","%#{word}")
    else
      tags = Tag.where("name Like?","%#{word}%")
    end

    return tags.inject(init = []) {|result, tag| result + tag.books}

  end

end
