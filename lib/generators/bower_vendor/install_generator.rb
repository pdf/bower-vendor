class BowerVendor::InstallGenerator < Rails::Generators::Base
  source_root Rails.root

  attr_accessor :utils

  class_option :update, type: :boolean, desc: 'Update bower assets (ie - `bower update`)'
  class_option :skip_git_ignore, type: :boolean, desc: 'Add vendored bower asset package directories to .gitignore'
  class_option :force_clean, type: :boolean, desc: 'Clean vendored bower assets without prompting'
  class_option :skip_clean, type: :boolean, desc: 'Skip cleaning vendored bower assets'
  class_option :include_dev_dependencies, type: :boolean, default: false, desc: 'Include bower devDependencies'
  desc 'Vendor bower assets based on bower.json'
  def bower_install
    if !options.skip_clean?
      generate options.force_clean? ? 'bower_vendor:clean --force' : 'bower_vendor:clean'
      generate 'bower_vendor:clean --cached'
    end

    action = options.update? ? 'update' : 'install'
    action << ' --production' if !options.include_dev_dependencies?
    say_status :run, "bower #{action}"
    `bower #{action}`

    @utils = BowerVendor::Utils.new

    utils.merged_paths.each do |package, paths|
      append_file '.gitignore', "\n# Vendored bower package '#{package}'\n" if !options.skip_git_ignore?
      case paths
      when Hash
        paths.each do |source, dest|
          vendor_asset(package, utils.prefixed_source(package, source), dest)
        end
      when Array
        paths.each do |source|
          vendor_asset(package, utils.prefixed_source(package, source))
        end
      when String
        vendor_asset(package, utils.prefixed_source(package, paths))
      else
        raise Thor::Error, set_color("Paths must be either Hash, Array or String, received: #{paths.class}", :red, :bold)
      end
    end
  end

  private
  def vendor_asset(package, source, dest=nil)
    if source == File.join(BowerVendor::BOWER_ROOT, package)
      err = <<-eos
        The '#{package}' package has a missing 'main' attribute, and cannot be handled automatically.
        Please encourage the maintainer to fix the package, and in the mean time, try overriding the
        sources in your 'bower.json'.
      eos
      raise Thor::Error, set_color(err, :red, :bold)
    elsif File.directory? source
      err = <<-eos
        The '#{package}' package has a broken 'main' attribute that specifies a directory (#{source}).  
        Please encourage the maintainer to fix the package, and in the mean time, try overriding the
        sources in your 'bower.json'.
      eos
      raise Thor::Error, set_color(err, :red, :bold)
    end
    file_ext = File.extname(source)
    case file_ext
    when '.js', '.coffee'
      prefix = 'javascripts'
    when '.css', '.scss', '.sass', '.less'
      prefix = 'stylesheets'
    when '.gif', '.png', '.jpg', '.svg'
      prefix = 'images'
    else
      prefix = 'media'
    end

    if dest
      dest = utils.prefixed_dest(package, prefix, dest)
    else
      dest = utils.prefixed_dest(package, prefix, File.basename(source))
    end
    append_file '.gitignore', "/#{File.join('vendor', 'assets', prefix, package)}\n" if !options.skip_git_ignore?
    copy_file(source, dest)
  end
end
