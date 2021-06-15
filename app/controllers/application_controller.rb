class ApplicationController < ActionController::API
  rescue_from SQLite3::ConstraintException, with: :on_database_validation
  rescue_from ArgumentError, with: :on_missing_parameters

  SQLITE_ERROR_MAPPER = {
    "UNIQUE constraint failed: contacts.email" => "Email already in use!",
    "All objects being inserted must have the same keys" => "At least one contact has missing value(s)!",
    "NOT NULL constraint failed: contacts.name" => "Name can't be blank!"
  }

  def on_database_validation(error)
    error_message = SQLITE_ERROR_MAPPER[error.to_s]
    render json: { error: error_message }, status: :unprocessable_entity
  end

  def on_missing_parameters(error)
    error_message = SQLITE_ERROR_MAPPER[error.to_s]
    render json: { error: error_message }, status: :unprocessable_entity
  end
end
