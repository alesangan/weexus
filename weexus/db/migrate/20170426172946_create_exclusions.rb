class CreateExclusions < ActiveRecord::Migration[5.0]
  def change
    create_table :exclusions do |t|
      t.string :word
      t.float :weighting

      t.timestamps
    end
  end
end
