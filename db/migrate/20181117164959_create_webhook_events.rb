class CreateWebhookEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :webhook_events do |t|
      t.bigint :webhook_id
      t.string :status
      t.json :response
      t.string :url
      t.string :zip_code
    end
  end
end
