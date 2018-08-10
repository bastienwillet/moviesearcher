require 'dotenv'
require 'themoviedb-api'

Dotenv.load

class SearchMovie
    def results(movie)
        Tmdb::Api.key(ENV["TMDB_KEY"])
        
        movies_array = []                                           # Cet array va contenir toutes les infos scrappées (un hash par film)

        temp = Tmdb::Search.movie(movie, page: 1)["results"]        # On scrappe pour récupérer la liste des films
        for i in 0..(temp.count - 1)
            hash_temp = {}                                          # Initialisation du fameux hash par film
            temp2 = Tmdb::Movie.detail(temp[i]["id"])               # On récupère les infos de chaque film
            hash_temp["title"] = temp2["title"]                     # On intège le titre dans notre hash
            if temp2["status"] == "Planned"                         # On voit si le film est sorti. Si ce n'est pas le cas, on intègre dans notre hash un "?" à la place de la date de sortie et du nom du réalisateur
                hash_temp["release"] = "?"
                hash_temp["director"] = "?"
            else
                hash_temp["release"] = temp2["release_date"]
                if temp2["production_companies"] == []              # On vérifie si la BD du site contient les infos "production_companies" et "imdb_id". Si ce n'est pas le cas -> directeur = "?"
                    hash_temp["director"] = "?"
                else
                    if temp2["imdb_id"] == nil
                        hash_temp["director"] = "?"
                    else
                        hash_temp["director"] = Tmdb::Movie.director(temp[i]["id"])[0]["name"]      # Et bim, le réalisateur
                    end
                end
            end
            if temp2["poster_path"] == nil                          # On intègre l'URL du poster si elle existe
                hash_temp["poster_URL"] = ""
            else
                hash_temp["poster_URL"] = temp2["poster_path"]
            end
            movies_array << hash_temp                               # ... Et on stocke tout ça dans l'array de départ
        end

        movies_array.each do |value|                                # Enfin on remplit le model
            Movie.create(title: value["title"], release: value["release"], director: value["director"], poster_URL: value["poster_URL"])
        end
    end
end
