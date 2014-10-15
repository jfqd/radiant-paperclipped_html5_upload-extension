# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "radiant-paperclipped_html5_upload-extension"

Gem::Specification.new do |s|
  s.name        = "radiant-paperclipped_html5_upload-extension"
  s.version     = RadiantPaperclippedHtml5UploadExtension::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = RadiantPaperclippedHtml5UploadExtension::AUTHORS
  s.email       = RadiantPaperclippedHtml5UploadExtension::EMAIL
  s.homepage    = RadiantPaperclippedHtml5UploadExtension::URL
  s.summary     = RadiantPaperclippedHtml5UploadExtension::SUMMARY
  s.description = RadiantPaperclippedHtml5UploadExtension::DESCRIPTION

  s.add_dependency "mimetype-fu", "~> 0.1.2"

  ignores = if File.exist?('.gitignore')
    File.read('.gitignore').split("\n").inject([]) {|a,p| a + Dir[p] }
  else
    []
  end
  s.files         = Dir['**/*'] - ignores
  s.test_files    = Dir['test/**/*','spec/**/*','features/**/*'] - ignores
  # s.executables   = Dir['bin/*'] - ignores
  s.require_paths = ["lib"]
  
  s.post_install_message = %{
  Add this to your radiant project by adding the following line to your environment.rb:
    config.gem 'radiant-paperclipped_html5_upload-extension', :version => '#{RadiantPaperclippedHtml5UploadExtension::VERSION}'
  }

end
