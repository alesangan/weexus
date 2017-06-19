class ChangeFieldTypeInPostTable < ActiveRecord::Migration[5.0]
  def change
    change_column :posts, :content, :longtext
  end
end
