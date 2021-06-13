require 'test_helper'

class GenerateContactsTest < ActiveSupport::TestCase
  test "#call" do
    result = GenerateContacts.new.call
    assert_kind_of Array, result
    assert_equal 10_000, result.size

    first_result_element = result.first
    assert_equal %i[name email], first_result_element.keys
    assert first_result_element[:email].ends_with?('example.com')
  end

  test "#call with amount params" do
    result = GenerateContacts.new(22).call
    assert_kind_of Array, result
    assert_equal 22, result.size
  end
end
