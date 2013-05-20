class BowerVendor::CleanGenerator < Rails::Generators::Base
  attr_accessor :utils

  class_option :force, type: :boolean, desc: 'Delete vendored bower assets without prompting'
  class_option :cached, type: :boolean, desc: "Delete only the bower cache from #{BowerVendor::BOWER_ROOT}"
  desc 'Cleans bower assets (CAUTION: Vendored asset directories for all bower packages will be deleted!)'
  def clean_packages
    unless Dir.exist? BowerVendor::BOWER_ROOT
      say_status :run, 'bower install --production'
      `bower install --production`
    end
    if !options.cached?
      @utils = BowerVendor::Utils.new
      utils.merged_paths.keys.each do |package|
        %w[javascripts stylesheets images].each do |prefix|
          path = File.join('vendor', 'assets', prefix, package)
          if Dir.exist? path
            if options.force? or yes?("Remove #{path}?", :cyan)
              remove_dir(path)
            end
          end
        end
      end
    else
      remove_dir(BowerVendor::BOWER_ROOT)
    end
  end
end
