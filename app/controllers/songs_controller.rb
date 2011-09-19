class SongsController < ApplicationController
  def index
    @songs = AWS::S3::Bucket.find(BUCKET).objects
  end

  def show
    @song = Song.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song }
    end
  end  




  def new
   @song = Song.new
   respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @song }
    end
  end

  def create
    @song = Song.new(params[:song])
    @song.user_id = current_user.id
    p :dbg => params[:song][:mp3file]
    respond_to do |format|
      if @song.save
        @song.upload_file(params[:song][:mp3file])
        format.html { redirect_to(@song, :notice => 'song was successfully created.') }
        format.xml  { render :xml => @song, :status => :created, :location => @song }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @song.errors, :status => :unprocessable_entity }
      end
    end
  end

  def upload
    begin
      AWS::S3::S3Object.store(sanitize_filename(params[:mp3file].original_filename), params[:mp3file].read, BUCKET, :access => :public_read)
      redirect_to root_path
    rescue
      render :text => "Couldn't complete the upload"
    end
  end

  def delete
    if (params[:song])
      AWS::S3::S3Object.find(params[:song], BUCKET).delete
      redirect_to root_path
    else
      render :text => "No song was found to delete!"
    end
  end

  private

  def sanitize_filename(file_name)
    just_filename = File.basename(file_name)
    just_filename.sub(/[^\w\.\-]/,'_')
  end
 
end
