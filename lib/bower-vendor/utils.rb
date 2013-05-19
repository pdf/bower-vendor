require 'ruby-bower'
require 'json'

class BowerVendor::Utils
  attr_accessor :bower_paths, :bower_json

  def initialize
    bower = Bower.new
    @bower_json = ::JSON.load(File.read('bower.json'))
    begin
      @bower_paths = bower.list(paths: true)
    rescue ::ExecJS::ProgramError => e
      err = 'failed to retrieve installed bowser components'
      err << ': ' << e.to_s if e.to_s
      raise RuntimeError, err
    end
  end

  def prefixed_source(package, path)
    if path =~ /^#{BowerVendor::BOWER_ROOT}/
      path
    else
      File.join(BowerVendor::BOWER_ROOT, package, path) 
    end
  end

  def prefixed_dest(package, prefix, path)
    File.join('vendor', 'assets', prefix, package, path)
  end

  def merged_paths
    if bower_json.has_key? 'sources'
      bower_json['sources'].each do |package, paths|
        bower_paths[package] = paths
      end
    end
    bower_paths
  end

end
