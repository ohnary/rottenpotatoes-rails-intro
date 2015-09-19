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
    session[:sort_by]  = params[:sort_by] if params[:sort_by]
    session[:ratings]  = params[:ratings] if params[:ratings]

    flash.keep
    if !params[:sort_by]
      if !params[:ratings]
        redirect_to movies_path({sort_by: session[:sort_by], ratings: session[:ratings]})
      else
        redirect_to movies_path({sort_by: session[:sort_by], ratings: params[:ratings]})
      end
    elsif !params[:ratings]
      redirect_to movies_path({sort_by: params[:sort_by], ratings: session[:ratings]})
    end
    
    @sort_column = session[:sort_by]
    @movies      = Movie.all

    @movies      = Movie.order("#{@sort_column}") if @sort_column
    @movies      = @movies.where(:rating=>session[:ratings].keys)  if session[:ratings]
 
    @all_ratings = Movie.all_ratings

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
