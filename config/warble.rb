Warbler::Config.new do |config|
  config.jar_name = "rbdc"
  config.dirs << 'db'
  config.dirs << 'bin'
  config.includes = FileList["Rakefile"]
  config.excludes = FileList["**/*/*.box"]
  config.bundle_without = []
  config.webxml.jruby.max.runtimes = 1
end