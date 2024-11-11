class TrafficDataController < ApplicationController
  def index
    traffic_data = TrafficDatum.all
    render json: traffic_data
  end

  def show
    traffic_datum = TrafficDatum.find(params[:id])
    render json: traffic_datum
  end
end
