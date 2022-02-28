class Movie < ActiveRecord::Base
    def self.all_ratings
       ["G","PG","R","PG-13"] 
    end
end
