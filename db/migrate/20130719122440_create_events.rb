class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.string :country
      t.string :locality
      t.date :date

      t.timestamps
    end
  end
end
