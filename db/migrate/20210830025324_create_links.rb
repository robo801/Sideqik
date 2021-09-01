class CreateLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :links do |t|
      t.references :user, null: false, foreign_key: true
      t.string :url, null: false
      t.string :short_link, limit: 8, null: false

      t.timestamps
    end
    add_index :links, :short_link, :unique => true
  end
end
