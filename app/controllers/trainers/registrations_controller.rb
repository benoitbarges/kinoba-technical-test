# frozen_string_literal: true

class Trainers::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, options = {})
    if resource.persisted?
      render json: {
        status: {
          code: 200,
          data: resource,
          message: 'Signed up successfully!'
        }
      }, status: :ok
    else
      render json: {
        status: {
          code: 422,
          errors: resource.errors.full_messages,
          message: 'Trainer could not be created successfully'
        }
      }, status: :unprocessable_entity
    end
  end
end
