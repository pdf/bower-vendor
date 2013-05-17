require 'json'
namespace :bower do
  desc 'vendor bower assets'
  task :vendor do
    sh 'bower install'
    BowerVendor::Utils.new().deploy_assets
  end

  desc 'update bower assets'
  task :update do
    sh 'bower update'
    BowerVendor::Utils.new().deploy_assets
  end

  desc 'clean bower assets'
  task :clean do
    BowerVendor::Utils.new().clean_packages
  end
end
