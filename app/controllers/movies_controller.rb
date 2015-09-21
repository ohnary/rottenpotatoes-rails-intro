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

    if(!params.has_key?(:sort_by) && !params.has_key?(:ratings))
      if(session.has_key?(:sort) || session.has_key?(:ratings))
        redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
      end
    end

    session[:sort_by]  = params[:sort_by] if params[:sort_by]
    session[:ratings]  = params[:ratings] if params[:ratings]

    #session[:ratings] cannot be used at view
    @selected_ratings = (session[:ratings].present? ? session[:ratings] : [])

    @sort_column = session[:sort_by]
    @movies      = Movie.all

    @movies      = @movies.order("#{@sort_column}") if @sort_column
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
