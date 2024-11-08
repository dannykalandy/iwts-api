class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: "Wallet", optional: true
  belongs_to :target_wallet, class_name: "Wallet", optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :validate_transaction_type

  after_save :update_wallet_balances

  private

  def validate_transaction_type
    if transaction_type == 'credit' && source_wallet.present?
      errors.add(:source_wallet, 'should be nil for credit transactions')
    elsif transaction_type == 'debit' && target_wallet.present?
      errors.add(:target_wallet, 'should be nil for debit transactions')
    end
  end

  def update_wallet_balances
    source_wallet&.update_balance!
    target_wallet&.update_balance!
  end
end