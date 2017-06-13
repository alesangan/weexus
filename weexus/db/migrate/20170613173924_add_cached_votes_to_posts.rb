class AddCachedVotesToPosts < ActiveRecord::Migration[5.0]
  def self.up
    add_column :posts, :cached_votes_total, :integer, :default => 0
  
  end
end
