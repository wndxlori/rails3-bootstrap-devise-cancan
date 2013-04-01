# This is where you initialize your client api_id and secret_key for Yubikey
# Set as environment variables, so you don't check the actuals into source control
Yubikey.configure do |config|
  config.api_id  = ENV['YUBIKEY_API_ID']
  config.api_key = ENV['YUBIKEY_API_KEY']
end
