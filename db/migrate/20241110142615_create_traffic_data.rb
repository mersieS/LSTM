class CreateTrafficData < ActiveRecord::Migration[7.0]
  def change
    create_table :traffic_data do |t|
      t.date :date
      t.integer :traffic_size

      t.timestamps
    end
  end
end
