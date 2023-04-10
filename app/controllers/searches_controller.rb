class SearchesController < ApplicationController
  before_action :authenticate_user!

  # 下記コードにて検索フォームからの情報を受け取る　formに合わせる
  # 検索モデル→params[:range]
  # 検索方法→params[:search]
  # 検索ワード→params[:word]

  def search
    @range = params[:range]
    @search = params[:search]
    @word = params[:word]

    if @range == "User"
      # user.ruとbook.rbに記述したself.looks(search,word)メソッドを使用
      @users = User.looks(@search, @word)
    elsif @range == "Book"
      @books = Book.looks(@search, @word)
    elsif @range == "tag" #if文追加！
    # tag.rbのクラスメソッド発動をし、tagの検索結果を@tagsに代入
      @tags = Tag.looks(@search, @word)
    end
  end
end
