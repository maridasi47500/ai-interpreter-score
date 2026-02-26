class CreateScores < ActiveRecord::Migration[8.0]
  def change
    create_table :scores do |t|
      t.string :title
      t.string :composer
      t.string :pic

      t.timestamps
    end
  end
end
