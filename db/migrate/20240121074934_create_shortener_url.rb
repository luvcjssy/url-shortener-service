class CreateShortenerUrl < ActiveRecord::Migration[7.0]
  def change
    create_table :shortener_urls do |t|
      t.string :original_url, null: false
      t.string :code, null: false
      t.datetime :expired_at, null: false

      t.timestamps
    end

    add_index :shortener_urls, :original_url, unique: true
    add_index :shortener_urls, :code, unique: true
  end
end
