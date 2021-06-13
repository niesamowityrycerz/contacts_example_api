require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  test "responders" do
    contact = Contact.new
    assert_respond_to contact, :name
    assert_respond_to contact, :first_name
    assert_respond_to contact, :last_name
    assert_respond_to contact, :email
    assert_respond_to contact, :created_at
    assert_respond_to contact, :updated_at
  end

  test "#valid?" do
    refute Contact.new.valid?
  end
end
