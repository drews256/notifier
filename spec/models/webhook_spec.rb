require 'rails_helper'

describe Webhook do
  it 'creates webhooks' do
    create(:webhook)
    expect(Webhook.find_by(name: 'webhook 1')).to be_present
  end

  context 'validations' do
    let(:webhook) { build(:webhook) }

    describe '#valid?' do
      it 'is not valid without a name' do
        webhook.name = nil
        expect(webhook).to_not be_valid
      end

      it 'is not valid without a url' do
        webhook.url = nil
        expect(webhook).to_not be_valid
      end

      it 'is not valid without a zip_code' do
        webhook.zip_code = nil
        expect(webhook).to_not be_valid
      end

      describe 'adds errors to the model' do
        describe '#name' do
          it 'validates presence' do
            webhook.name = nil
            webhook.valid?
            expect(webhook.errors[:name]).to include "Can't be blank"
          end

          it 'validates uniqueness' do
            webhook.name = '1'
            webhook.save!
            invalid_webhook = build(:webhook, name: '1')
            invalid_webhook.valid?
            expect(invalid_webhook.errors[:name]).to include "has already been taken"
          end
        end

        it 'validates url' do
          webhook.url = nil
          webhook.valid?
          expect(webhook.errors[:url]).to include "Can't be blank"
        end

        it 'validates zip_code' do
          webhook.zip_code = nil
          webhook.valid?
          expect(webhook.errors[:zip_code]).to include "Can't be blank"
        end
      end
    end
  end
end
