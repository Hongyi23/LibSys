class BooksController < ApplicationController
  def new
    @book = Book.new()
  end

  def show
    @book = Book.find(params[:id])
    @history = current_member.histories.build(member_id: current_member.id, book_id: @book.id, action: "checkout")

    if current_member.admin? && @book.status == "checkout"
      @owner = @book.histories.last.member_id
    end
  end

  def create
    @book = Book.new(book_params)
    @book.status = "available"
    if @book.save
      flash[:success] = "Book added"
      redirect_to @book
    else
      render 'new'
    end
  end

  def index
    @books = Book.paginate(page: params[:page])
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update_attributes(book_params)
      flash[:success] = "Book updated"
      redirect_to @book
    else
      render 'edit'
    end
  end

  def destroy
    Book.find(params[:id]).destroy
    flash[:success] = "Book deleted"
    redirect_to books_url
  end
  
  def checkout
   @book =  Book.find(params[:id])
   if @book.update_attributes(:status=>'checked out')
      flash[:success] = "Book checked out"
   end
   redirect_to @book
  end
  
  def book_params
    params.require(:book).permit(:ISBN, :title, :author, :description, :status)
  end

end
