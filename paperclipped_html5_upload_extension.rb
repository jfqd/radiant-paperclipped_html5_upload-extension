# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'
require "radiant-paperclipped_html5_upload-extension"

class PaperclippedHtml5UploadExtension < Radiant::Extension
  version     RadiantPaperclippedHtml5UploadExtension::VERSION
  description RadiantPaperclippedHtml5UploadExtension::DESCRIPTION
  url         RadiantPaperclippedHtml5UploadExtension::URL
  
  define_routes do |map|
    map.with_options(:controller => 'admin/assets') do |asset|
      asset.upload_assets "/admin/assets/uploader",     :action => 'upload'
    end
  end
  
  def activate
    Radiant::Config['roles.bulk_uploader'] = '' unless Radiant::Config['roles.bulk_uploader']
    
    Asset.send :include, UploadableAsset
    Admin::AssetsController.send :include, AssetsControllerExtension
    PaperclippedHtml5UploadExtension.admin.asset.index.add :bottom, 'admin/assets/upload_bottom'
    
    begin
      Admin::AssetsController.class_eval {
        helper :paperclipped_uploader
        only_allow_access_to :upload, :describe,
            :when => (Radiant::Config['roles.bulk_uploader'].split(',').collect{ |s| s.strip.underscore.downcase }.map(&:to_sym) << :site_admin),
            :denied_url => { :controller => 'pages', :action => 'index' },
            :denied_message => 'You must have site-administrator privileges to perform this action.'
      }
    rescue
      # get migrations pass
    end
  
  end
  
  def deactivate
  end
  
end
