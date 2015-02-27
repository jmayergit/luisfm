class ArtistsController < ApplicationController
  require 'rest-client'

  def index
    @artists = Artist.all
    render json: @artists
  end

  def create
    artist = params['artist']['name']

    def getSimilar(artist)
      # last fm uri + method parameter expressed as 'package.method' + limit + key
      uri = "http://ws.audioscrobbler.com/2.0/?method=artist.getsimilar&artist=#{artist}&limit=3&api_key=ddbf408cce195ed82a523b1d395e5c9b&format=json"
      # simple restclient request, possible formats from api are xml, json
      response = RestClient.get(uri)
      # parse json string into json object
      json = JSON.parse(response)
      # array of artist hashes
      artists = json["similarartists"]["artist"]
    end

    def getVideo(artist)
      # format last fm response
      artist = artist.split().join("")
      # youtube api url + weird part and snippet + type [video, playlist, channel] + limit results
      url = "https://www.googleapis.com/youtube/v3/search?part=id%2C+snippet&q=#{artist}&type=video&maxResults=1&key=AIzaSyCztszklccaoguqRDrzz-Xk5OmHJTbLkiE"
      responseYtube = RestClient.get(url)
      # response parsed into json object
      jsonYtube = JSON.parse(responseYtube)
      # index into json hash to retireve video id
      ytid = jsonYtube["items"][0]["id"]["videoId"]
    end

    similarArtists = getSimilar(artist)
    # persisting to database make youtube api request for each similar artist to retrieve a video for each artist
    similarArtists.each do |artist|
      @artist = Artist.new
      name = artist["name"]
      ytid = getVideo(name)
      # image size options = [small, medium, large, extralarge, mega]
      xtra_large_image = artist["image"][3]["#text"]
      mbid = artist["mbid"]
      @artist.name = name
      @artist.image = xtra_large_image
      @artist.mbid = mbid
      @artist.ytid = ytid
      @artist.save
    end
    @artists = Artist.all
    render json: @artists
  end
end
