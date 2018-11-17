require 'rails_helper'
require 'support/web_mocks'

describe WeatherJob do
  context 'without a valid zipcode' do
    let(:subject) { described_class.new }

    before do
      subject.perform(nil)
    end

    it 'can be invalid' do
      expect(subject).to_not be_valid
    end

    it 'has errors when we dont pass a zipcode' do
      expect(subject.errors[:zip_code]).to eq 'zip_code is missing'
    end
  end

  describe '.perform' do
    context 'with a valid zipcode' do
      let(:subject) { described_class.new }

      before do
        stub_quiet_request
        subject.perform(10000)
      end

      it 'is valid with a zipcode' do
        expect(subject).to be_valid
      end

      it 'has a zipcode' do
        expect(subject.zip_code).to eq 10000
      end

      it 'retrieves weather status' do
        expect(subject.response.code).to eq 200
      end

      it 'reschedules the job' do
        expect(subject).to receive(:reschedule)
        subject.perform(10000)
      end
    end
  end
end
