class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :property, index: true
      t.string :account
      t.date :date
      t.decimal :income
      t.decimal :expense
      t.decimal :miscellaneous
      t.text :comment

      t.timestamps
    end
  end
end
