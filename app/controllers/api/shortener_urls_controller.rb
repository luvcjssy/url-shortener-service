module Api
  class ShortenerUrlsController < BaseController
    def encode
      existed_url = ShortenerUrl.find_by(original_url: encode_params[:original_url])
      if existed_url
        if Time.zone.now < existed_url.expired_at
          render json: { success: true, data: { shortener_url: "#{request.base_url}/#{existed_url.code}" } }, status: 200
        else
          render json: error_format(422, 'URL is expired'), status: 422
        end
      else
        process_new_url
      end
    end

    def decode
      shortener_url = ShortenerUrl.find_by!(code: decode_params[:code].strip)
      if Time.zone.now < shortener_url.expired_at
        render json: { success: true, data: shortener_url.as_json(only: [:original_url]) }, status: 200
      else
        render json: error_format(422, 'URL is expired'), status: 422
      end
    end

    private

    def encode_params
      raise ActionController::ParameterMissing.new(:original_url) if params[:original_url].blank?
      params.permit(:original_url)
    end

    def decode_params
      raise ActionController::ParameterMissing.new(:code) if params[:code].blank?
      params.permit(:code)
    end

    def process_new_url
      available_code = AvailableCode.order('random()').first
      if available_code
        shortener_url = ShortenerUrl.new(original_url: encode_params[:original_url],
                                         code: available_code.code,
                                         expired_at: 1.month.from_now)
        if shortener_url.save
          available_code.destroy
          render json: { success: true, data: { shortener_url: "#{request.base_url}/#{shortener_url.code}" } }, status: 200
        else
          render json: error_format(422, shortener_url.errors.full_messages), status: 422
        end
      else
        render json: error_format(422, 'Service Unavailable'), status: 422
      end
    end
  end
end