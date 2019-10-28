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

get '/:name' do
  base = []
  params[:name].split(",").each do |name|
    unless bases.has_key? name
      return [400, "Names: " + bases.keys.join(" ")]
    end
    base += bases[name]
  end

  markov(base, 200)
end

get '/' do
  [400, "Usage: /name,name2,..."]
end

