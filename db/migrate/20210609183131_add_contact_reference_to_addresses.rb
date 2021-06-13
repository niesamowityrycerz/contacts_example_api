class AddContactReferenceToAddresses < ActiveRecord::Migration[6.1]
  def change
    add_reference :addresses, :contact, foreign_key: true, null: false
  end
end
