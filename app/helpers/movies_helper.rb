module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def IsChecked(rating)
    checked=true
    if !params[:ratings].nil? 
      checked = params[:ratings].include? rating
    end
    return checked
  end
end
