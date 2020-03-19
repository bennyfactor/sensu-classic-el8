name "eventmachine"

dependency "ruby"

default_version "1.2.0.1"
source url: "https://github.com/eventmachine/eventmachine/archive/v1.2.0.1.tar.gz",
       md5: "f2fd0f4a268f333cc8f965170c24918a"

relative_path "eventmachine-1.2.0.1"

build do
  env = with_standard_compiler_flags(with_embedded_path)

  ENV["CC"] = "gcc"
  ENV["CXX"] = "g++"

  patch_env = env.dup

  command "gem install rake-compiler", env: env

  command "rake clean", env: env
  command "rake compile", env: env
  command "rake gem", env: env

  command "gem install pkg/eventmachine-1.2.0.1.gem", env: env
end
