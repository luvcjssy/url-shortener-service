class Api::BaseController < ApplicationController
  include Api::ErrorFormatter

  rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found
  rescue_from ActionController::ParameterMissing, with: :render_params_missing

  def render_record_not_found
    render json: error_format(404, 'Record not found'), status: 404
  end

  def render_params_missing(param)
    render json: error_format(400, "#{param}"), status: 400
  end
end
