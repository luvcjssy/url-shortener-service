require 'rails_helper'

describe ShortLinkService, type: :service do
  subject(:service) { described_class.generator(date_time, date_time) }

  describe '#generator' do
    let(:date_time) { Time.zone.at 1705891362 }

    it 'returns available codes' do
      service
      expect(AvailableCode.count).to eq 1
      expect(AvailableCode.last.code).to eq 'b1BUqY'
    end
  end
end
