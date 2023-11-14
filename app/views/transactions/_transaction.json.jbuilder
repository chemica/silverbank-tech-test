json.extract! transaction, :id, :sender_id, :receiver_id, :amount, :status, :error_message, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
