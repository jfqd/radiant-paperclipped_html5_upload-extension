# encoding: UTF-8
module AssetsControllerExtension
  
  def upload
    begin
      if request.post?
        @asset = Asset.new(params[:asset])
        @asset.uploaded_file = params[:asset][:asset][0]
        @asset.save!
        # fix filename after upload
        @asset.asset_file_name = normalize_file_name(@asset.asset_file_name)
        @asset.save(false)
        render :json => { asset_id: @asset.id }, :status => :ok
      end
    rescue Exception => e
      logger.warn "[AssetsControllerExtension#upload] file upload error: #{e.inspect}"
      render :json => { error: e.message }, :status => 500
    end
  end
  
  def describe
    begin
      if request.put?
        @asset = Asset.find(params[:id])
        @asset.update_attributes(params[:asset])
        @asset.save!
        render :json => {}, :status => :ok
      else
        raise "wrong method"
      end
    rescue Exception => e
      logger.warn "[AssetsControllerExtension#upload] file upload error: #{e.inspect}"
      render :json => { error: e.message }, :status => 500
    end
  end
  
  private
  
  def normalize_file_name(filename)
    _filename  = filename.force_encoding("UTF-8")
    _extension = File.extname(_filename)
    _basename  = _filename.gsub(/#{_extension}$/, "")
    "#{ _basename.force_encoding("UTF-8").umlaut_filter.gsub( /[^\w\-]/, '_' ) }#{ _extension }"
  end
end
