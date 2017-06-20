module ApplicationHelper
  def tag_cloud (tags, classes)
    max = tags.sort_by(&:count).last
    tags.each do |tag|
      if tag.status == "Active"
      index = tag.count.to_f / max.count * (classes.size - 1)
      
      yield(tag, classes[index.round])
      end
    end
  end
end


# ORIGINAL TEXT
#module ApplicationHelper
#  def tag_cloud (tags, classes)
#    max = tags.sort_by(&:count).last
#    tags.each do |tag|
#      index = tag.count.to_f / max.count * (classes.size - 1)
#      yield(tag, classes[index.round])
#    end
#  end
#end



def sortable(column,title=nil)
  title ||=column.titleize
  direction = column==sort_column && sort_direction == "asc" ? "desc" : "asc"
  link_to title, :sort => column,:direction => direction
end
