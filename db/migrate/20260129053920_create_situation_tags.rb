class CreateSituationTags < ActiveRecord::Migration[8.1]
  def change
    create_table :situation_tags do |t|
      t.references :situation, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
