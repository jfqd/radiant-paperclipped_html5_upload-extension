# encoding: utf-8
module UploadableAsset
  
  class String
    def umlaut_filter
      self.gsub("ä", "ae").gsub("ö", "oe").gsub("ü", "ue").gsub("Ä", "Ae").gsub("Ö", "Oe").gsub("Ü", "Ue").gsub("ß", "ss") rescue self
    end
  end
  
  def uploaded_file=(upload)
    asset_file_name = if defined?(RadiantMagicExtension)
      self.title.force_encoding("UTF-8").strip.umlaut_filter.gsub( /[^\w\.\-]/, '_' )
    else
      self.title
    end
    self.asset = upload
    self.asset_file_name = asset_file_name
    self.asset_file_size ||= upload.size rescue 0
    self.asset_content_type = File.mime_type?(self.title)
  end

end