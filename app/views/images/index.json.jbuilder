json.array!(@images) do |image|
  json.extract! image, :id, :url, :user_id
  json.url image_url(image, format: :json)
end
