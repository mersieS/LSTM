require 'net/http'
require 'open3'
require 'json'

class DataController < ApplicationController
  def train_model
    url = URI("https://data.brla.gov/resource/n9u7-h9i7.json")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    filtered_data = data.select { |item| item["pagepath"] == "/" }
    pageviews_list = filtered_data.map { |item| item["pageviews"].to_i if item["pageviews"] }.compact

    traffic_data = pageviews_list
    input_data = traffic_data.map(&:to_f)

    stdout, stderr, status = Open3.capture3("python3 bin/python_scripts/lstm_model.py", stdin_data: input_data.to_json)

    if status.success?
      render json: { status: 'success', message: 'Model başarıyla eğitildi ve kaydedildi.' }
    else
      render json: { status: 'error', message: stderr }
    end
  end

  def predict_data
    traffic_data = TrafficDatum.order(id: :desc).limit(1000).pluck(:traffic_size)

    input_data = traffic_data.map(&:to_f)

    stdout, stderr, status = Open3.capture3("python3 bin/python_scripts/model_caller.py", stdin_data: input_data.to_json)

    if status.success?

      begin
        result = JSON.parse(stdout.strip)
        predicted_value = result['predicted_value'].to_f

        max_traffic_size = traffic_data.max
        min_traffic_size = traffic_data.min
        predicted_user_count = predicted_value * (max_traffic_size - min_traffic_size) + min_traffic_size

        render json: { status: 'success', predicted_value: predicted_user_count }
      rescue JSON::ParserError => e
        render json: { status: 'error', message: "Failed to parse JSON: #{e.message}, stdout: #{stdout}" }
      end
    else
      render json: { status: 'error', message: stderr }
    end
  end
end
