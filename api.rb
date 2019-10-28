require 'sinatra'
require_relative 'markov.rb'

bases = {
  "kb" => ["bases/kb.txt"],
  "lgd" => ["bases/lgd.txt"],
  "k200v" => ["bases/k200v.txt"]
}

get '/:name/:words' do
  unless bases.has_key? params[:name]
    return [400, "Names: " + bases.keys.join(" ")]
  end

  markov(bases[params[:name]], params[:words].to_i)
end

get '/' do
  [400, "Usage: /name/words"]
end

