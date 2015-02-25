class ArtistsController < ApplicationController
  require 'rest-client'

  def index
    @artists = Artist.all
    render json: @artists
  end

  def create
    # index into params hash to retrieve form parameter
    artist = params['artist']['name']
    # base uri to access last fm api + method parameter expressed as 'package.method'
    uri = "http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=#{artist}&limit=3&api_key=ddbf408cce195ed82a523b1d395e5c9b&format=json"
    # simple restclient request, possible formats from api are xml, json
    response = RestClient.get(uri)
    # parse json string into json object
    json = JSON.parse(response)
    # array of artist hashes
    artists = json["similarartists"]["artist"]
    @artists = json["similarartists"]["artist"]
    # persisting to database
    artists.each do |artist|
      @artist = Artist.new
      name = artist["name"]
      # image size options = [small, medium, large, extralarge, mega]
      xtra_large_image = artist["image"][3]["#text"]
      mbid = artist["mbid"]
      @artist.name = name
      @artist.image = xtra_large_image
      @artist.mbid = mbid
      @artist.save
    end
  end
end
