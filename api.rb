require 'sinatra'
require_relative 'markov.rb'

bases = {
  "kb" => ["bases/kb.txt"],
  "lgd" => ["bases/lgd.txt"],
  "k200v" => ["bases/k200v.txt"]
}

before do
  response.headers['Access-Control-Allow-Origin'] = '*'
  content_type 'text/plain'
end

get '/:name/?:seed?' do
  base = []
  params[:name].split(",").each do |name|
    p name
    unless bases.has_key? name
      return [400, "Names: " + bases.keys.join(" ")]
    end
    base += bases[name]
  end

  if params[:seed].nil?
    markov(base, 200)
  else
    markov(base, 200, params[:seed].to_i)
  end
end

get '/' do
  [400, "Usage: /name,name2,...[/seed]"]
end

