class MoviesController < ApplicationController
    def index
        Movie.delete_all
    end
    
    def search
        @movie = params[:movie][:movie_name]
        SearchMovie.new.results(@movie)
        @movies = Movie.all
    end
end
