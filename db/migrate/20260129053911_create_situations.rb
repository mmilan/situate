class CreateSituations < ActiveRecord::Migration[8.1]
  def change
    create_table :situations do |t|
      t.references :user, null: false, foreign_key: true
      t.text :message
      t.integer :visibility

      t.timestamps
    end
  end
end
