# encoding: utf-8
require 'mimetype_fu'

module UploadableAsset
  
  class String
    def umlaut_filter
      self.gsub("ä", "ae").
           gsub([97, 204, 136].pack('c*').force_encoding('UTF-8'),"ae").
           gsub("ö", "oe").
           gsub([111, 204, 136].pack('c*').force_encoding('UTF-8'),"oe").
           gsub("ü", "ue").
           gsub([117, 204, 136].pack('c*').force_encoding('UTF-8'),"ue").
           gsub("Ä", "Ae").
           gsub([65, 204, 136].pack('c*').force_encoding('UTF-8'),"Ae").
           gsub("Ö", "Oe").
           gsub([79, 204, 136].pack('c*').force_encoding('UTF-8'),"Oe").
           gsub("Ü", "Ue").
           gsub([85, 204, 136].pack('c*').force_encoding('UTF-8'),"Ue").
           gsub("ß", "ss").
           gsub("®", "")
    rescue Exception => e
      Rails.logger.warn("[UploadableAsset#umlaut_filter] Error: #{e.message}")
      self
    end
  end
  
  def uploaded_file=(upload)
    asset_file_name = self.title.force_encoding("UTF-8").strip.umlaut_filter.gsub( /[^\w\.\-]/, '_' )
    self.asset = upload
    self.asset_file_name = asset_file_name
    self.asset_file_size ||= upload.size rescue 0
    self.asset_content_type = File.mime_type?(self.title)
  end

end