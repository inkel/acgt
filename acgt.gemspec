# encoding: utf-8

Gem::Specification.new do |s|
  s.name        = "acgt"
  s.version     = "0.0.1"
  s.summary     = "DNA for simple generators"
  s.description = "DNA for simple generators"
  s.authors     = ["Leandro Lopez"]
  s.email       = ["inkel.ar@gmail.com"]
  s.homepage    = "http://inkel.github.com/acgt"
  s.files       = `git ls-files 2> /dev/null`.split("\n")
  s.licenses    = ["MIT"]

  s.executables = ["acgt"]

  s.add_dependency "mote"
  s.add_dependency "clap"
end
