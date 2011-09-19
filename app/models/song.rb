class Song < ActiveRecord::Base
  belongs_to :user

  attr_accessible :mp3file

  def upload_file(file)
   begin
     AWS::S3::S3Object.store(sanitize_filename(file.original_filename), 
         file.read, BUCKET, :access => :public_read)
     #redirect_to root_path
     return true
   rescue
      
    return false 
     #render :text => "Couldn't complete the upload"
   end
 end

private

  def sanitize_filename(file_name)
    just_filename = File.basename(file_name)
    just_filename.sub(/[^\w\.\-]/,'_')
  end
end
