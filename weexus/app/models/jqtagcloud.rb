class Jqtagcloud

  def set_exclusion_list ( exclusion_list )
    @exclusion_list = exclusion_list.flatten
  end

  def set_content ( content )
    @content = ActionView::Base.full_sanitizer.sanitize(content).downcase.gsub /\W+/, ' '
  end

  def set_counter ( counter )
    @counter = counter
  end

  # Main method
  def createCloud(content, exclusion_list, counter = 25)

    set_content(content)
    set_exclusion_list(exclusion_list)
    set_counter(counter)

    words = @content
    counts = Hash.new 0
    words.split(' ').each do |word|
      if word.length > 3
        counts[word] += 1
      end
    end
    counts = counts.sort_by {|_key, value| value}.reverse.to_h
    hashnew = counts.reject { |k, _| @exclusion_list.include? k }
    #  raise hashnew.inspect
    arrnew = Array.new
    counter = @counter
    hashnew.each do|key,weight|
      hashp=Hash.new
      hashp['text'] = key
      hashp['weight']= weight
      arrnew.push(hashp)
      counter = counter - 1
      if counter==0
        break
      end
    end

    return arrnew

  end

end
