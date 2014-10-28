class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.references :user, index: true
      t.string :nickname
      t.text :description
      t.string :address

      t.timestamps
    end
  end
end
