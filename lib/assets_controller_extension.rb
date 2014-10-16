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
end
