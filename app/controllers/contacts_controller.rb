# frozen_string_literal: true

class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :update, :destroy]

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

    #contacts = []
#
    ## ~30 sec.
    #contact_attrs.each do |attrs|
    #  contact = Contact.new(attrs)
    #  contact.save!
    #  contacts << {id: contact.id, name: contact.name, email: contact.email}
    #end

    ## REFACTORING vol.1 ~ 30 sec.
    # contacts = Contact.create!(contact_attrs)

    ## REFACTORING vol.2 ~30 sec.
    Contact.transaction do 
      @contacts = Contact.create!(contact_attrs)
    end

    ## REFACTORING vol.2 ~30 sec. -> it does not trigger ActiveRecord validations and callbacks, but restrictions on db level are not violated
    # begin
    #   Contact.insert_all!(contact_attrs)
    #   contacts = Contact.last(10000)
    # rescue => e
    #   error = { 
    #     error: e.message
    #   }
    # end

    render json: @contacts || error, status: :created
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
end
