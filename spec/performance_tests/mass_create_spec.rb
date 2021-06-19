require 'rails_helper'

RSpec.describe "Mass create performance", type: :unit do 


  it 'checks current performance' do 
    expect {
      data = GenerateContacts.new.call
      emails = data.collect { |contact| contact[:email] }
      Contact.insert_all!(data)
      contacts = Contact.select(:id, :name, :email).where(email: emails)
    }.to perform_under(800).ms
  end

  context 'when block of codes' do 
    before(:each) do 
      data = GenerateContacts.new.call
      @emails = data.collect { |contact| contact[:email] }
      Contact.insert_all(data)
    end

    it 'compares options to retrieve objects' do 
      expect {
        Contact.select(:id, :name, :email).where(email: @emails)
      }.to perform_faster_than {
        Contact.where(email: @emails).pluck(:id, :name, :email)
      }.at_least(15).times
    end

    it 'checks performance of current implementation' do 
      expect {
        Contact.select(:id, :name, :email).where(email: @emails)
      }.to perform_under(20).ms
    end
  end 
end