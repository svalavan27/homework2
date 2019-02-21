class Movie < ActiveRecord::Base
    def self.all_movieratings
    array_movieratings = Array.new
    self.select("rating").uniq.each{ |rating_items| array_movieratings.push(rating_items.rating)}
    array_movieratings.sort.uniq
    end
end
