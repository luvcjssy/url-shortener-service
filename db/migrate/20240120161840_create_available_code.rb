class CreateAvailableCode < ActiveRecord::Migration[7.0]
  def change
    create_table :available_codes do |t|
      t.string :code, null: false
      t.timestamps

      t.index :code, unique: true
    end

    # Generate unique short link before and store it in DB
    ShortLinkService.generator
  end
end
