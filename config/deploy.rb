require 'bundler/capistrano'

server "localhost", :app, :db, :primary => true

ssh_options[:port] = 2222
ssh_options[:keys] = "~/.vagrant.d/insecure_private_key"

set :user, "vagrant"
set :group, "vagrant"
set :use_sudo, false

set :deploy_to, "/opt/trinidad"
set :application, "rbdc"
set :repository, "."
set :scm, :none
set :deploy_via, :copy
set :copy_exclude, [".git","log","tmp","*.box","*.war",".idea",".DS_Store"]
set :rake, 'jruby --1.9 -S rake'

set :default_environment,
    'PATH' => "/opt/jruby/bin:$PATH",
    'JSVC_ARGS_EXTRA' => '-user vagrant'
set :bundle_dir, ""
set :bundle_flags, "--system --quiet"

before "deploy:setup", "deploy:install_bundler"
after "deploy:create_symlink", "deploy:assets"

namespace :deploy do
  task :install_bundler, :roles => :app do
    run "sudo gem install bundler"
    run "sudo ln -s /lib/x86_64-linux-gnu/libncursesw.so.5 /lib/x86_64-linux-gnu/libncursesw.so"
    run "sudo ln -s /usr/lib/x86_64-linux-gnu/libpanelw.so.5 /usr/lib/x86_64-linux-gnu/libpanel.so"
  end

  task :assets, :roles => :app do
    run("cd #{deploy_to}/current && #{rake} assets:precompile RAILS_ENV=#{rails_env}")
  end

  desc "Starting rails"
  task :start, :roles => :app do
    run "/etc/init.d/trinidad start"
  end

  desc "Stopping rails"
  task :stop, :roles => :app do
    run "/etc/init.d/trinidad stop"
  end

  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end
end