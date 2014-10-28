json.array!(@properties) do |property|
  json.extract! property, :id, :user_id, :nickname, :description, :address
  json.url property_url(property, format: :json)
end
