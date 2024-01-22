require 'rails_helper'

describe Api::ShortenerUrlsController do
  before do
    date_time = Time.zone.at(1705891362) # code = b1BUqY
    ShortLinkService.generator(date_time, date_time)
  end

  describe '#encode' do
    let(:action) { post :encode, body: encode_params.to_json, as: :json }

    context 'valid params' do
      let(:encode_params) { { original_url: 'https://oivan.com' } }

      it 'returns status 200' do
        action
        expect(response).to have_http_status 200
      end

      it 'returns new shortener url' do
        action
        body = JSON.parse(response.body)
        expect(body['success']).to be true
        expect(body['data']['shortener_url']).to eq "#{request.base_url}/b1BUqY"
      end

      it 'returns existed shortener url without expired' do
        ShortenerUrl.create(original_url: 'https://oivan.com', code: 'b1BUqY', expired_at: 1.month.from_now)
        action
        expect(ShortenerUrl.count).to eq 1
      end

      context 'with expired url' do
        before { ShortenerUrl.create(original_url: 'https://oivan.com', code: 'b1BUqY', expired_at: 1.month.ago) }

        it 'returns status 422' do
          action
          expect(response).to have_http_status 422
        end

        it 'returns error message' do
          action
          body = JSON.parse(response.body)
          expect(body['success']).to be false
          expect(body['error']['message']).to eq 'URL is expired'
        end
      end
    end

    context 'invalid params' do
      context 'with missing original url' do
        let(:encode_params) { { original_url: '' } }

        it 'returns status 400' do
          action
          expect(response).to have_http_status 400
        end

        it 'return missing original_url' do
          action
          body = JSON.parse(response.body)
          expect(body['success']).to be false
          expect(body['error']['message']).to eq 'param is missing or the value is empty: original_url'
        end
      end

      context 'with wrong url format' do
        let(:encode_params) { { original_url: 'wrong' } }

        it 'returns status 422' do
          action
          expect(response).to have_http_status 422
        end

        it 'return wrong format error' do
          action
          body = JSON.parse(response.body)
          expect(body['success']).to be false
          expect(body['error']['message']).to eq 'Original url is invalid'
        end
      end
    end
  end

  describe '#decode' do
    let(:action) { post :decode, body: decode_params.to_json, as: :json }

    context 'valid params' do
      before { ShortenerUrl.create(original_url: 'https://oivan.com', code: 'b1BUqY', expired_at: 1.month.from_now) }

      let(:decode_params) { { code: 'b1BUqY' } }

      it 'returns status 200' do
        action
        expect(response).to have_http_status 200
      end

      it 'returns original url' do
        action
        body = JSON.parse(response.body)
        expect(body['success']).to be true
        expect(body['data']['original_url']).to eq 'https://oivan.com'
      end

      context 'with expired url' do
        before { ShortenerUrl.find_by(code: 'b1BUqY').update(expired_at: 1.month.ago) }

        it 'returns status 422' do
          action
          expect(response).to have_http_status 422
        end

        it 'returns existed url' do
          action
          body = JSON.parse(response.body)
          expect(body['success']).to be false
          expect(body['error']['message']).to eq 'URL is expired'
        end
      end
    end

    context 'invalid params' do
      context 'with missing code' do
        let(:decode_params) { { code: '' } }

        it 'returns status 400' do
          action
          expect(response).to have_http_status 400
        end

        it 'return missing code' do
          action
          body = JSON.parse(response.body)
          expect(body['success']).to be false
          expect(body['error']['message']).to eq 'param is missing or the value is empty: code'
        end
      end

      context 'with wrong code' do
        let(:decode_params) { { code: 'wrong' } }

        it 'returns status 404' do
          action
          expect(response).to have_http_status 404
        end

        it 'return not found code' do
          action
          body = JSON.parse(response.body)
          expect(body['success']).to be false
          expect(body['error']['message']).to eq 'Record not found'
        end
      end
    end
  end
end