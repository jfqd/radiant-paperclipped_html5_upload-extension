# encoding: utf-8
module PaperclippedUploaderHelper
  
  def allowed_by_role?
    allowed_roles = Radiant::Config['roles.bulk_uploader'].split(',').collect{ |s| s.strip.underscore.downcase }
    allowed_roles << "site_admin" # allow site_admin to do bulk uploads
    allowed_roles.any? { |role| @current_user.has_role?(role.to_s.to_sym) }
  end
  
end