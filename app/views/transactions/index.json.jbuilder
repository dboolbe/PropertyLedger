json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :property_id, :account, :date, :income, :expense, :miscellaneous, :comment
  json.url transaction_url(transaction, format: :json)
end
