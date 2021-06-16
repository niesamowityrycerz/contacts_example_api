# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :update, :destroy]
  before_action :adjust_contact_params, only: [:mass_create]

  # GET /contacts
  def index
    @contacts = Contact.all

    render json: @contacts
  end

  # GET /contacts/1
  def show
    render json: @contact
  end

  # POST /contacts
  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      render json: @contact, status: :created, location: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # POST /mass_create
  def mass_create
    contact_attrs = params[:contact_attrs] || GenerateContacts.new.call

    # contacts = []
    # #old way
    # #it takes around  30 sec.
    # contact_attrs.each do |attrs|
    #   contact = Contact.new(attrs)
    #   contact.save!
    #   contacts << {id: contact.id, name: contact.name, email: contact.email}
    # end

    Contact.insert_all!(contact_attrs)
    contacts = Contact.select(:id, :name, :email).last(contact_attrs.size)
    render json: contacts, status: :created
  end

  # PATCH/PUT /contacts/1
  def update
    if @contact.update(contact_params)
      render json: @contact
    else
      render json: @contact.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contacts/1
  def destroy
    @contact.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def contact_params
    params.require(:contact).permit(:name, :email, addresses_attributes: [ :city, :street, :street_number ])
  end

  def adjust_contact_params
    # ensure each contact hash has :created_at and :updated_at attributes
    # SQlite will not throw validation error
    # there is "null: False" validation on db level
    if !params[:contact_attrs].nil?
      params[:contact_attrs].each do |contact|
        if !contact.has_key? :created_at && :updated_at 
          contact.merge!({
            created_at: Time.now,
            updated_at: Time.now
          })
        end
      end
    end 
  end
end
