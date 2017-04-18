class AddPasswordResetToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :reset_digest, :string, default: false
    add_column :users, :reset_sent_at, :datetime
  end
end
