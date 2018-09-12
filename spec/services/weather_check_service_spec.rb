require 'rails_helper'

describe WeatherCheckService do
  describe '.call' do
    # NOTE: (2018-09-12) tim => spec/support/web_mocks.rb provides helpers that
    # can be used to stub outgoing HTTP requests.
    xit 'retrieves weather status for each zip code'
    xit 'schedules a WebhookJob to execute each Webhook in a background job'
  end
end
