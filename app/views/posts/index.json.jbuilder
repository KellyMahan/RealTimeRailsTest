json.array!(@posts) do |post|
  json.extract! post, :id, :content, :subject
  json.url post_url(post, format: :json)
end
