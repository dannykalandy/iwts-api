class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.references :source_wallet, foreign_key: { to_table: :wallets }, null: true
      t.references :target_wallet, foreign_key: { to_table: :wallets }, null: true
      t.decimal :amount, precision: 15, scale: 2, null: false
      t.string :transaction_type # 'credit' or 'debit'
      t.text :description

      t.timestamps
    end
  end
end