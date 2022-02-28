class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    # the condition of redirecting to other pages
    if ! (request.original_url =~ /movies/) 
      session.clear
    end
    
    # if params[:ratings].nil? && params[:sort].nil? 
    #   # the condition of returning from intro to a movie
    #   if (!session[:ratings].nil? || !session[:sort].nil?)
    #     params[:ratings] = session[:ratings]
    #     params[:sort] = session[:sort]
    #   # the condition of directly visiting the root
    #   else
    #     session[:ratings] = nil
    #     session[:sort] = nil
    #     @movies = Movie.all
    #   end
    
    # the condition of coming back
    if params[:ratings].nil? && params[:sort].nil? && (!session[:ratings].nil? || !session[:sort].nil?)
         params[:ratings] = session[:ratings]
         params[:sort] = session[:sort]
    end
    
    # the condition of visiting the root
    if params[:ratings].nil? && params[:sort].nil?
       @movies = Movie.all
       session[:ratings] = nil
       session[:sort] = nil
    elsif params[:ratings].nil?
      @sort_key=params[:sort]
      @movies = Movie.order(params[:sort])
      session[:ratings] = nil
      session[:sort] = params[:sort]
    elsif params[:sort].nil?
      @rating_keys = params[:ratings]
      @movies = Movie.where("rating IN (?)",@rating_keys.keys)
      session[:ratings] = params[:ratings]
      session[:sort] = nil
    else
      @rating_keys = params[:ratings]
      @sort_key=params[:sort]
      @movies = Movie.where("rating IN (?)",@rating_keys.keys).order(params[:sort])
      session[:ratings] = params[:ratings]
      session[:sort] = params[:sort]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
