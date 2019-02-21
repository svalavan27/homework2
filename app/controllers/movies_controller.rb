class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_movieratings
    
    if params[:ratings]
      session[:set_movieratings] = params[:ratings]
    elsif !session[:set_movieratings]   
      session[:set_movieratings] = Hash.new
      @all_ratings.each {|rating| session[:set_movieratings][rating] = 1}
    end
    
    @set_movieratings = session[:set_movieratings]

    
    if params[:moviesort_by]
      session[:moviesort_by] = params[:moviesort_by]
    end
    
    @moviesort_column = params[:moviesort_by]
    
    @movies = Movie.where({rating:  session[:set_movieratings].keys })
    
    if session[:moviesort_by]
      @movies = @movies.order(session[:moviesort_by])
    end

    url_rotten_potatoes = {'ratings'=> session[:set_movieratings], 'moviesort_by'=> session[:moviesort_by]}
    if ( session[:set_movieratings] != params[:ratings] || session[:moviesort_by] != params[:moviesort_by] )
      redirect_to(url_rotten_potatoes)
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

end
