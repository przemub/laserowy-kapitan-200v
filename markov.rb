#!/usr/bin/ruby

markov = Hash.new
names = []

abort "Usage: ruby #{$PROGRAM_NAME} source_files" if ARGV.length < 1

ARGV.each { |name|
  file = File.open name
  text = file.read
  words = text.split(" ")
  names += text.scan /^[0-9A-ZĄŚŻŹĆŁÓŃ ]+$/
  
  prev = words[0]
  words[1..-1].each { |word|
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

wrs = -> (markov) { markov.max_by { |_, weight| rand ** (1.0 / weight) }.first }

200.times {
  last_word = wrs[markov[last_word]]
  output += " " unless /^[.?!,]+$/.match(last_word)
  output += last_word
}

until last_word =~ /[.?!,]+/
  last_word = wrs[markov[last_word]]
  output += " " unless /^[.?!,]+$/.match(last_word)
  output += last_word
end

names.uniq!
p names
names.each { |name|
  output.gsub! name, "\n\n"+name+"\n\n"
}
output.gsub! /^ /, ''

puts output

