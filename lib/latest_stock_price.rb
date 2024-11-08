require 'net/http'
require 'json'

class LatestStockPrice
  BASE_URL = "https://rapidapi.com/suneetk92/api/latest-stock-price"

  def initialize(api_key)
    @api_key = api_key
  end

  def price(symbol)
    request("/price", symbol: symbol)
  end

  def prices(symbols)
    request("/prices", symbols: symbols.join(","))
  end

  def price_all
    request("/price_all")
  end

  private

  def request(endpoint, params = {})
    uri = URI("#{BASE_URL}#{endpoint}")
    uri.query = URI.encode_www_form(params.merge(api_key: @api_key))
    res = Net::HTTP.get_response(uri)
    JSON.parse(res.body)
  rescue StandardError => e
    Rails.logger.error("Stock price API request failed: #{e.message}")
    {}
  end
end