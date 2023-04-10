class BooksController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @newbook = Book.new
    @book_comment = BookComment.new
    # @bookに紐づくtagを全て取得
    @book_tags = @book.tags
  end

  def index
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:star_count]
      @books = Book.star_count
    else
      @books = Book.all
    end
    # @books = Book.all
    @book = Book.new
    @user = current_user
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    # 受け取った値を,で区切って配列にする
    tag_list = params[:book][:name].split(',')
    if @book.save
      # book.rbで設定したsave_tags(sent-tags)メソッドを発動
      # 結果として@bookにタグを保存している。詳しい処理内容はbook.rbで確認
      @book.save_tags(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    # 編集フォームで登録済のタグを初期値として表示する為に必要
    @tag_list=@book.tags.pluck(:name).join(',')
  end

  def update
    @book = Book.find(params[:id])
    # 受け取った値を,で区切って配列にする
    tag_list=params[:book][:name].split(',')
    if @book.update(book_params)
      # book.rbで設定したsave_tags(sent-tags)メソッドを発動
      # 結果として@bookにタグを保存している。詳しい処理内容はbook.rbで確認
      @book.save_tags(tag_list)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  # book_paramsに:starを追加　これでcreate、update時に保存ができる！
  def book_params
    params.require(:book).permit(:title, :body, :star)
  end

  def is_matching_login_user
    @book = Book.find(params[:id])
    user_id = @book.user_id
    unless user_id == current_user.id
      redirect_to books_path
    end
  end

end
