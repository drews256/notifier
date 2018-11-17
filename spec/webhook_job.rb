require 'rails_helper'
require 'support/web_mocks'

describe WebhookJob do
  context 'without a valid webhook id' do
    let(:subject) { described_class.new }

    before do
      subject.perform(nil)
    end

    it 'can be invalid' do
      expect(subject).to_not be_valid
    end

    it 'has errors when we dont pass a webhook_id' do
      expect(subject.errors[:webhook_id]).to eq 'webhook_id is missing'
    end
  end

  describe '.perform' do
    # NOTE: (2018-09-12) tim => spec/support/web_mocks.rb provides helpers that
    # can be used to stub outgoing HTTP requests.

    context 'with a valid webhook id' do
      let(:webhook) { create(:webhook) }
      let(:subject) { described_class.new }

      before do
        stub_quiet_request
        subject.perform(webhook.id)
      end

      it 'is valid with a webhook_id' do
        expect(subject).to be_valid
      end

      it 'has a webhook_id' do
        expect(subject.webhook_id).to eq webhook.id
      end

      it 'retrieves weather status' do
        expect(subject.response.code).to eq 200
      end

      it 'reschedules the job' do
        expect(subject).to receive(:reschedule)
        subject.perform(webhook.id)
      end

      it 'creates a webhook event' do
        expect { subject.perform(webhook.id) }.to change { WebhookEvent.count }
      end
    end
  end
end
