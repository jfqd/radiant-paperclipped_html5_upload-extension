# encoding: UTF-8
module AssetsControllerExtension
  
  def upload
    begin
      if request.post?
        @asset = Asset.new(params[:asset])
        @asset.uploaded_file = params[:asset][:asset][0]
        @asset.save!
        render :json => { asset_id: @asset.id }, :status => :ok
      end
    rescue Exception => e
      logger.warn "[AssetsControllerExtension#upload] file upload error: #{e.inspect}"
      render :json => { }, :status => 500
    end
  end
  
end
