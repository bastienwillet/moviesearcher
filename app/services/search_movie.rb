require 'dotenv'
require 'themoviedb-api'

Dotenv.load

class SearchMovie
    def results(movie)
        Tmdb::Api.key(ENV["TMDB_KEY"])
        
        movies_array = []

        temp = Tmdb::Search.movie(movie, page: 1)["results"]
        for i in 0..(temp.count - 1)
            hash_temp = {}
            temp2 = Tmdb::Movie.detail(temp[i]["id"])
            hash_temp["title"] = temp2["title"]
            if temp2["status"] == "Planned"
                hash_temp["release"] = "?"
                hash_temp["director"] = "?"
            else
                hash_temp["release"] = temp2["release_date"]
                if temp2["production_companies"] == []
                    hash_temp["director"] = "?"
                else
                    if temp2["imdb_id"] == nil
                        hash_temp["director"] = "?"
                    else
                        hash_temp["director"] = Tmdb::Movie.director(temp[i]["id"])[0]["name"]
                    end
                end
            end
            if temp2["poster_path"] == nil            
                hash_temp["poster_URL"] = ""
            else
                hash_temp["poster_URL"] = temp2["poster_path"]
            end
            movies_array << hash_temp
        end

        movies_array.each do |value|
            Movie.create(title: value["title"], release: value["release"], director: value["director"], poster_URL: value["poster_URL"])
        end
    end
end