class BowerVendor::ConfigureGenerator < Rails::Generators::Base
  desc 'Creates/updates .bowerrc for use with bower-vendor'
  def configure_bower
    if File.exist? '.bowerrc'
      gsub_file '.bowerrc', /"directory":\s*"[^"]*"\s*,/, "\"directory\": \"#{BowerVendor::BOWER_ROOT}\""
    end
    create_file '.bowerrc', {directory: BowerVendor::BOWER_ROOT}.to_json

    append_file '.gitignore', "\n# Temporary bower components\n/tmp/bower_components\n"
  end
end
