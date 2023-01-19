# frozen_string_literal: true

class Trainers::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, options = {})
    render json: {
      status: {
        code: 200,
        trainer: current_trainer,
        message: 'Trainer signed in successfully!'
      }
    }
  end

  def respond_to_on_destroy
    begin
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.fetch(:secret_key_base)).first
      current_trainer = Trainer.find(jwt_payload['sub'])
    rescue JWT::ExpiredSignature
      current_trainer = nil
    end
    if current_trainer
      render json: {
        status: 200,
        message: 'Trainer signed out successfully!'
      }, status: :ok
    else
      render json: {
        status: 401,
        message: 'Trainer has no active session'
      }, status: :unauthorized
    end
  end
end
