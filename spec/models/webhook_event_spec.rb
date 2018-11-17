require 'rails_helper'

describe WebhookEvent do
	describe '#webhook' do
		it 'responds to webhook' do
			expect(WebhookEvent.new).to respond_to(:webhook)
		end
	end
end
