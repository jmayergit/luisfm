class ArtistsController < ApplicationController
  require 'rest-client'

  def index
    @artist = Artist.new
    # uri = "http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=cher&api_key=ddbf408cce195ed82a523b1d395e5c9b&format=json"
    # @response = RestClient.get(uri)
    @artists = Artist.all
  end

  def create
    artist = params['artist']['name']
    uri = "http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=#{artist}&limit=3&api_key=ddbf408cce195ed82a523b1d395e5c9b&format=json"
    response = RestClient.get(uri)
    json = JSON.parse(response)
    @artist = Artist.new
    @artist.name = json["similarartists"]["artist"][0]["name"]
    @artist.save()

    # similars = @response.similarities.artist
    # similarities.artist[0].name
    # similars.each do |similar|
    #   p similar.name
    # end
  end
end
