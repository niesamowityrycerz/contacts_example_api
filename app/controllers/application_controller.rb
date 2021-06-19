class ApplicationController < ActionController::API

  rescue_from SQLite3::ConstraintException, ArgumentError, with: :on_database_validation
  rescue_from ActiveModel::UnknownAttributeError, with: :unknown_attribute_handler


  ERROR_MAPPER = {
    "UNIQUE constraint failed: contacts.email" => "Email already in use!",
    "All objects being inserted must have the same keys" => "At least one contact has missing value(s)!",
    "NOT NULL constraint failed: contacts.name" => "Name is missing!",
    "NOT NULL constraint failed: contacts.email" => "Email is missing!"
  }

  def on_database_validation(error)
    ERROR_MAPPER.has_key?(error.to_s)
    error_message = ERROR_MAPPER[error.to_s]
    render json: { error: error_message }, status: :unprocessable_entity
  end

  def unknown_attribute_handler(error)
    error_message = error.to_s.capitalize
    render json: { error: error_message }, status: :unprocessable_entity
  end


end
