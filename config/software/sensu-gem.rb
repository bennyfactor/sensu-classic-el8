name "sensu-gem"
default_version "0.22.2"

dependency "ruby"
dependency "rubygems"
dependency "libffi"
dependency "eventmachine"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  env['CC'] = 'gcc'

  patch_env = env.dup

  files_dir = "#{project.files_path}/#{name}"

  command "gem fetch sensu -v #{version}", env: env

  command "gem unpack sensu-#{version}.gem", env: env
  command "LC_CTYPE=C && LANG=C && find ./sensu-#{version} -type f -exec sed 's/1.0.9.1/1.2.0.1/g' \{\} \\\;", env: env
  command "cd sensu-#{version}&& gem build sensu.gemspec", env: env


  gem "install sensu-#{version}/sensu-#{version}.gem" \
      " --bindir '#{install_dir}/embedded/bin'" \
      " --no-ri --no-rdoc", env: env

  gem "install mixlib-cli" \
      " --version '1.5.0'" \
      " --no-ri --no-rdoc", env: env

  gem "install sensu-plugin" \
      " --version '1.2.0'" \
      " --no-ri --no-rdoc", env: env

  share_dir = File.join(install_dir, "embedded", "share", "sensu")
  bin_dir = File.join(install_dir, "bin")
  embedded_bin_dir = File.join(install_dir, "embedded", "bin")

  # make directories
  mkdir("#{install_dir}/bin")
  mkdir("#{share_dir}/etc/sensu")

  # config.json.example
  copy("#{files_dir}/config.json.example", "#{share_dir}/etc/sensu")

  # sensu-install
  copy("#{files_dir}/sensu-install", bin_dir)
  command("chmod +x #{bin_dir}/sensu-install")

  # make symlinks
  link("#{embedded_bin_dir}/sensu-client", "#{bin_dir}/sensu-client")
  link("#{embedded_bin_dir}/sensu-server", "#{bin_dir}/sensu-server")
  link("#{embedded_bin_dir}/sensu-api", "#{bin_dir}/sensu-api")
end
