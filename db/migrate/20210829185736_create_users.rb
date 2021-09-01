class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :token, null: true

      t.timestamps
    end
    add_index :users, :username, :unique => true
    add_index :users, :token, :unique => true
  end
end
