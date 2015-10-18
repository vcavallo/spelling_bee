#! /usr/bin/env ruby

require 'ruby-dictionary'
require 'pry'

class Speller

  def initialize(req, poss, max_letters, word_file_path = "/usr/share/dict/words")
    @req = req
    @poss = poss
    @max_letters = max_letters
    @all = poss << req
    @real_words = []
    @maybe_words = []
    @dictionary = Dictionary.from_file(word_file_path, "\n", false)
    puts "built dictionary from #{ word_file_path }"
  end

  def generate
    letter_number = [*5..10].sample
    word = ""
    letter_number.times do
      word += @all.sample
      #puts "building... #{ word }"
    end
    word += @req
    #puts "finished! #{ word }"
    return word
  end

  def make_words_old(number_of_words)
    number_of_words.times do
      word = generate
      @maybe_words << word
      puts "added '#{ word }' to list of possibiliites"
    end
  end

  def make_words(letter_number)
    @maybe_words << @all.repeated_permutation(letter_number).collect do |t|
      t.join("")
    end
  end

  def test_words
    i = 1
    @maybe_words = @maybe_words.flatten
    total = @maybe_words.count
    @maybe_words.each do |word|
      puts "testing word #{ i } of #{ total }..."
      if @dictionary.exists?(word)
        @real_words << word
        #puts "success! '#{ word }' is a word."
      end
      i += 1
    end
  end
  def run(max_letters = 7)
    letter_count = [*5..@max_letters]
    letter_count.each do |letters|
      puts "making words with #{ letters } letters..."
      make_words(letters)
    end
    test_words
    puts "all done! looks like there are #{ @real_words.length } found."
    puts "they are: #{ @real_words.join(", ") }"
    words_with_req = @real_words.select do |word|
      word.include?(@req)
    end
    puts "of those words, only these #{ words_with_req.length } contain a '#{ @req }': #{ words_with_req.join(", ") }"
  end

end

puts "starting up....."
if ARGV.length > 0
  if ["-h", "--help"].include?(ARGV[0])
    puts "usage: spelling_bee.rb [required_letter] [other_letters_no_spaces] [max_letter_number]"
  else
    req = ARGV[0]
    letters = ARGV[1].split("")
    max_letters = ARGV[2].to_i
    a = Speller.new(req, letters, max_letters)
    puts "ready, set, go!"
    a.run
  end
else
  puts "usage: spelling_bee.rb [required_letter] [other_letters_no_spaces] [max_letter_number]"
end

