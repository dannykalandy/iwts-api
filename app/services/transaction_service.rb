class TransactionService
  def self.transfer(source_wallet, target_wallet, amount, description = "")
    ApplicationRecord.transaction do
      Transaction.create!(
        source_wallet: source_wallet,
        target_wallet: target_wallet,
        amount: amount,
        transaction_type: 'debit',
        description: description
      )

      Transaction.create!(
        source_wallet: nil,
        target_wallet: target_wallet,
        amount: amount,
        transaction_type: 'credit',
        description: description
      )
    end
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error("Transaction failed: #{e.message}")
    raise
  end
end