class SongsController < ApplicationController
  def index
    @songs = AWS::S3::Bucket.find(BUCKET).objects 
  end

  def upload
  end

  def delete
  end

end
