#!/usr/bin/ruby

def markov(files, num_words, seed=Random.new_seed)
  markov = Hash.new
  names = []

  files.each { |name|
    file = File.open name
    text = file.read
    text.gsub! '################################', '\n'
    words = text.split(" ")
    names += text.scan /^[0-9A-ZĄŚŻŹĆŁÓŃ ]+$/
    
    prev = words[0]
    words[1..-1].each { |word|
      if word == "\ufeffODCINEK"
        prev = word
        next
      end

      punctuation = /^(.*?)([.?!,\n]*)$/.match word
      
      markov[prev] = Hash.new(0) if markov[prev].nil?
      markov[prev][punctuation[1]] += 1

      unless punctuation[2].empty?
        markov[punctuation[1]] = Hash.new(0) if markov[punctuation[1]].nil?
        markov[punctuation[1]][punctuation[2]] += 1
        prev = punctuation[2]
      else
        prev = word
      end
    }
  }

  last_word = "\ufeffODCINEK"
  output = last_word

  rng = Random.new seed
  wrs = -> (markov) { markov.max_by { |_, weight| rng.rand ** (1.0 / weight) }.first }

  num_words.times {
    last_word = wrs[markov[last_word]]
    output += " " unless /^[.?!,]+$/.match(last_word)
    output += last_word
  }

  until last_word =~ /[.?!]+/
    last_word = wrs[markov[last_word]]
    output += " " unless /^[.?!,]+$/.match(last_word)
    output += last_word
  end

  names.uniq!
  p names
  output.gsub! /([.?!]) ([A-Z ĄŻĘŚĆŃÓŁ0-9]+) ([A-ZĄŻĘŚĆŃÓŁ][a-zążęśćńół ])/, "\\1\n\n\\2\n\n\\3"

  output
end

if __FILE__ == $0
  puts markov(ARGV, 200)
end

