require 'test_helper'

class ContactsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contact = contacts(:one)
    @contact.email = "e#{SecureRandom.alphanumeric(8)}@example.com"
  end

  test "#index" do
    get contacts_url, as: :json
    assert_response :success
  end

  test "#create" do
    assert_difference('Contact.count') do
      assert_difference('Address.count') do
        post contacts_url, params: { 
          contact: { 
            email: @contact.email,
            name: @contact.name,
            first_name: 'Jan', 
            last_name: 'Kowalski',
            addresses_attributes: [{
              city: 'Jan', 
              street: 'Kowalski',
              street_number: 21 }]
          }
        }, as: :json
      end
    end 
    

    assert_response 201
  end

  test "#mass_create" do
    #skip("Refactor needed")

    time = Time.now.to_i
    p "Start at: #{time}"
    assert_difference('Contact.count', 10000) do
      post mass_create_contacts_url, as: :json
    end

    now = Time.now.to_i
    p "End at: #{now}"
    p "Delta: #{now - time} seconds"
    assert_response 201
  end

  test "#mass_create when email uniqueness violated" do 
    params = [ 
      {
        name: 'test_1',
        email: 'test@example.com',
        created_at: Time.now,
        updated_at: Time.now
      },
      {
        name: 'test_2',
        email: 'test@example.com',
        created_at: Time.now,
        updated_at: Time.now
      }
    ]
    post mass_create_contacts_url, params: { contact_attrs: params }, as: :json

    assert_equal "Email already in use!", response.parsed_body["error"]
    assert_response 422
  end

  test "#mass_create when one contact has missing value" do 
    params = [ 
      {
        name: 'test_1',
        email: 'test_1@example.com',
        created_at: Time.now,
        updated_at: Time.now
      },
      {
        email: 'test@example.com',
        created_at: Time.now,
        updated_at: Time.now
      }
    ]
    post mass_create_contacts_url, params: { contact_attrs: params }, as: :json
    assert_equal "At least one contact has missing value(s)!", response.parsed_body["error"]
    assert_response 422
  end

  test "#mass_create when contacts do not have 'name' attribute" do 
    params = [ 
      {
        email: 'test_1@example.com',
        created_at: Time.now,
        updated_at: Time.now
      },
      {
        email: 'test_2@example.com',
        created_at: Time.now,
        updated_at: Time.now
      }
    ]
    post mass_create_contacts_url, params: { contact_attrs: params }, as: :json

    assert_equal "Name is missing!", response.parsed_body["error"]
    assert_response 422
  end

  test "#mass_create when contacts do not have 'email' atribute" do 
    params = [ 
      {
        name: 'test_1',
        created_at: Time.now,
        updated_at: Time.now
      },
      {
        name: 'test_2',
        created_at: Time.now,
        updated_at: Time.now
      }
    ]
    post mass_create_contacts_url, params: { contact_attrs: params }, as: :json

    assert_equal "Email is missing!", response.parsed_body["error"]
    assert_response 422
  end

  test "#mass_create when unkown argument is passed" do
    unknown_attr = :alien
    params = [ 
      {
        created_at: Time.now,
        updated_at: Time.now
      },
      {
        created_at: Time.now,
        updated_at: Time.now
      }
    ]
    params.collect { |contact| contact[unknown_attr] = "alien" }

    post mass_create_contacts_url, params: { contact_attrs: params }, as: :json
    
    assert_equal "Unknown attribute '#{unknown_attr}' for contact.", response.parsed_body["error"]
    assert_response 422
  end


  test "#mass_create when created_at and updated_at are not passed" do 
    params = []
    10000.times do |i|
      params << {
        name: "test_#{i}",
        email: "test_#{i}@example.com"
      }
    end

    post mass_create_contacts_url, params: { contact_attrs: params }, as: :json
    assert_response 201
  end

  test "#show" do
    get contact_url(@contact), as: :json
    assert_response :success
  end

  test "#update" do
    patch contact_url(@contact), params: { contact: { email: @contact.email, name: @contact.name } }, as: :json
    assert_response 200
  end

  test "#destroy" do
    assert_difference('Contact.count', -1) do
      delete contact_url(@contact), as: :json
    end

    assert_response 204
  end
end
