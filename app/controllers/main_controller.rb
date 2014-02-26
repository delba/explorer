class MainController < ApplicationController
  def search
    venues = client.search_venues(
      ll: params[:ll],
      categoryId: params[:categoryId]
    )

    render json: venues
  end

private

  def client
    @client ||= Foursquare2::Client.new(
      client_id: Rails.application.secrets.foursquare_client_id,
      client_secret: Rails.application.secrets.foursquare_client_secret,
      api_version: Date.current.to_s.gsub('-', '')
    )
  end
end
