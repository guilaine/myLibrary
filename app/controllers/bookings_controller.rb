class BookingsController < ApplicationController
  def index
    @booking = Booking.new
    # borrowed books
    @bookings = Booking.all
  end

  def new
    @booking = Booking.new
    @users = User.all
    # only available books
    @books = Book.all.select {|book| book.status == 'available'}
  end

  def create
    @booking = Booking.new(bookings_params)
    if @booking.save
      redirect_to root_path
      @book = @booking.book
      @book.status = "borrowed"
      @book.save
      flash[:notice] = "#{@book.title} was borrowed."
    else
      render :new
    end
  end

  def destroy
    # return a book
    @booking = Booking.find(params[:booking][:id])
    @book = @booking.book
    @book.status = "available"
    @book.save
    @booking.destroy
    redirect_to root_path
    flash[:notice] = "#{@book.title} was returned."
  end

  private

  def bookings_params
    params.require(:booking).permit(:user_id, :book_id)
  end
end
