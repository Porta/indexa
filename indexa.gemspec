# encoding: utf-8

Gem::Specification.new do |s|
  s.name              = "indexa"
  s.version           = "0.0.1"
  s.summary           = "Indexa indexes an array of words in a redis backend"
  s.description       = "Indexa indexes an array of words in a redis backend to be searched by Busca, the simple redis search"
  s.authors           = ["Julián Porta"]
  s.email             = ["julian@porta.sh"]
  s.homepage          = "https://github.com/Porta/indexa"
  s.files             = `git ls-files`.split("\n")
  s.license           = "MIT"
  s.add_development_dependency "cutest", '~> 1.2'
  s.add_runtime_dependency "redic", '~> 1.4'
  s.add_runtime_dependency "msgpack", '~> 0.5'
end
