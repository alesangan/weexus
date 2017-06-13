class Post < ApplicationRecord
  belongs_to :user
  acts_as_votable
  has_many :taggings
  has_many :tags, through: :taggings
  validates :content, presence: true, allow_blank: false


  def get_tag_list
    self.tags.collect do |tag|
      tag.name
    end.reject(&:blank?).join(", ")
end

  #def get_tag_list
  #  self.tags.collect do |tag|
  #    tag.name
  #  end.join(", ")
#  end



  def split_tag_list(tags_string)
    tag_names = tags_string.collect{|s| s.strip.downcase}.uniq
    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
    self.tags = new_or_found_tags
  end


#  def tag_list=(tags_string)
#    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
#    new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
#    self.tags = new_or_found_tags
#  end


  def self.tagged_with(name)
    Tag.find_by!(name: name).posts
  end


  def self.tag_counts
    Tag.select('tags.*, count(taggings.tag_id) as count').joins(:taggings).group('taggings.tag_id')
  end

  def self.search(search)
    where("name LIKE ?", "%#{search}%")
    where("content LIKE ?", "%#{search}%")
  end


end
