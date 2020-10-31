# What is RAKE?
# Rapid Automatic Keyword Extraction, or RAKE is used for extracting and ranking the keywords/phrases out of a document without any other context except for the document itself.

# The algorithm works by first building up phrases out of words that are between stop words (things like “the”, “and” or “a”) and then discarding the stop words.

# After this it counts up the number of times each word occurs in all the phrases to find each word’s frequency score.

# The algorithm then sums the number of times each word occurs with every other word in all the phrases to get a degree or co-occurrence score.

# To get the final ranked list of phrases it generates a score for each word in the phrase by dividing the degree/co-occurrence count of the word by the frequency of the word in the document, then sums those scores across all the words in the phrase.

# This means if a word is in the document a lot but is dispersed randomly throughout the phrases it is a less important word and reduces the rank of the phrases it does show up in, conversely if the word shows up consistently in word match ups and has a lower number of overall occurrences then it will increase the ranking of the phrase it is found in.

# TODO: Write documentation for `Rake`
require "cadmium_tokenizer"

module Cadmium
  module Keywords
    extend self
    VERSION = "1.0.0"

    class AbstractKeywordExtractor
      # word_tokenizer : Cadmium::Tokenizer::Aggressive = Cadmium::Tokenizer::Aggressive.new
      # sentence_tokenizer : Cadmium::Tokenizer::Sentence = Cadmium::Tokenizer::Sentence.new
    end

    class Rake < AbstractKeywordExtractor
      # word_tokenizer : Cadmium::Tokenizer::Aggressive = Cadmium::Tokenizer::Aggressive.new
      # sentence_tokenizer : Cadmium::Tokenizer::Sentence = Cadmium::Tokenizer::Sentence.new
      # phrase_tokenizer : Cadmium::Tokenizer::Sentence = Cadmium::Tokenizer::Sentence.new
      # include Cadmium::Tokenizer::StopWords
      NUMBER_REGEX     = /^-*[0-9,\.]+$/
      STOP_WORDS       = File.read("#{__DIR__}/en.txt").split("\n") # .to_set
      STOP_WORDS_REGEX = /#{STOP_WORDS.to_a.map { |w| "\\b#{w}(?![\\w-])" }.join("|")}/i
      property options = {min_phrase_length: 1, max_phrase_length: 2}
      property word_tokenizer : Cadmium::Tokenizer::Base # ::Pragmatic.new(numbers: :none)

      def initialize
        # @word_tokenizer = Cadmium::Tokenizer::Pragmatic.new(numbers: :none, minimum_length: 6, punctuation: :none, clean: true)
        @word_tokenizer = Cadmium::Tokenizer::Aggressive.new
      end

      def to_regex(words : Set(String)) : Regex
        /#{words.to_a.map { |w| "\\b#{w}(?![\\w-])" }.join("|")}/i
      end

      private def phrase_delimiter(word)
        return "****" if STOP_WORDS.includes?(word)
        word
      end

      def phrases_tokenizer(sentences : Array(String))
        sentences.map { |sentence| @word_tokenizer.tokenize(sentence.downcase).map { |word| phrase_delimiter(word) }.join(" ").split("****").select { |phrase| acceptable?(phrase) } }.flatten

        # sentences.map { |sentence|
        #   sentence.downcase.split(STOP_WORDS_REGEX)

        #   .map { |element| @word_tokenizer.tokenize(element).join(" ") }.select { |phrase| acceptable?(phrase) } # .select { |phrase| phrase.size > 5 } #
        # }.flatten
      end

      def word_scores(sentences : Array(String))
        frequencies = Hash(String, Int32).new
        degrees = Hash(String, Int32).new

        phrases_tokenizer(sentences).each do |phrase|
          words = @word_tokenizer.tokenize(phrase) # .reject { |word| word =~ NUMBER_REGEX }
          # words = Cadmium::Tokenizer::Aggressive.new.tokenize(phrase)
          words.each do |word|
            frequencies[word] = 1 unless frequencies.has_key?(word)
            frequencies[word] += 1
            degrees[word] = 0 unless degrees.has_key?(word)
            degrees[word] += words.size - 1
          end
        end

        frequencies.each do |word, frequency|
          degrees[word] += frequency
        end

        scores = Hash(String, Float32).new
        frequencies.each do |word, frequency|
          scores[word] = (degrees[word] / frequency).to_f32
        end
        scores
      end

      def extract(text : String)
        keywords = Hash(String, Float32).new
        sentences = Cadmium::Tokenizer::Sentence.new.tokenize(text)
        phrases = phrases_tokenizer(sentences)
        word_scores = word_scores(sentences)
        phrases.each do |phrase|
          # if @options[:min_frequency] > 1
          #   next if phrases.count(phrase) < @options[:min_frequency]
          # end
          words = @word_tokenizer.tokenize(phrase).reject { |word| word.matches?(NUMBER_REGEX) }
          keywords[phrase.strip] = words.map { |word| word_scores[word] }.sum
        end
        keywords.to_a.sort_by { |_, value| value }.to_h.keys.reverse
        # keywords.select { |word, score|
        #   score >= @options[:min_score]
        # }.sort_by(&:last).reverse.to_h
      end

      def acceptable?(phrase)
        !phrase.empty? &&
          phrase.size >= @options[:min_phrase_length] &&
          phrase.split(/\s/).size <= @options[:max_phrase_length] &&
          phrase.scan(/[a-zA-Z]/).size > 0 &&
          phrase.scan(/[a-zA-Z]/).size > phrase.scan(/\d/).size
      end
    end
    # end

    # def generate_candidate_keywords(text : String, stop_words : Set(String), minCharacters : Int32, maxWords : Int32) : Array(String)
    #       tokenizer = Cadmium::Tokenizer::Aggressive.new
    #       all_words = tokenizer.tokenize(text)
    #       all_words_without_stop_words = all_words.map { |word| "###" if stop_words.includes?(word) }
    #       all_phrases = all_words_without_stop_words.join(" ").split("###")
    #       all_phrases
    # end

    #     def calculate_word_scores(text : String, stop_words : Set(String)) : Array(String)
    # phrases = generate_candidate_keywords(text, stop_words, minCharacters, maxWords)
    #       word_frequency = Hash(String, Int32).new
    #       word_degree = Hash(String, Int32).new
    #       phrases.each do |phrase|
    #         word_list = tokenizer.tokenize(phrase)
    #         word_list_degree = word_list.size -1
    #         word_list.each do |word|
    #           word_frequency.has_key?(word) ? (word_frequency[word] += 1) : (word_frequency[word] = 1)
    #           word_degree.has_key?(word) ? (word_degree[word] += word_list_degree) : (word_degree[word] = word_list_degree)
    #         end
    #       end
    #       word_frequency.keys.each do |word|
    #       word_degree[word] = word_degree[word] + word_frequency[word]
    #       end
    #       word_score = Hash(String, Float32).new
    #             word_frequency.keys.each do |word|
    #       word_score[word] = word_degree[word] / (word_frequency[word]
    #     end
    #     word_score
    #     end

    # def generate_candidate_keyword_scores(text : String, stop_words : Set(String), word_score : Hash(String, Float32), minFrequency : Int32)
    #     keyword_candidates = {}
    #     for phrase in phrase_list:
    #         if phrase_list.count(phrase) >= minFrequency:
    #             keyword_candidates.setdefault(phrase, 0)
    #             word_list = separate_words(phrase)
    #             candidate_score = 0
    #             for word in word_list:
    #                 candidate_score += word_score[word]
    #             keyword_candidates[phrase] = candidate_score
    #     keyword_candidates
    #             end

    # def get_keywords(text : String, stop_words : Set(String) = STOP_WORDS, minCharacters : Int32 = 1, maxWords : Int32 = 5, minimum_frequency : Int32 = 1) : Array(String)
    #   word_tokenizer = Cadmium::Tokenizer::Aggressive.new
    #   sentence_tokenizer = Cadmium::Tokenizer::Sentence.new
    #   all_words = word_tokenizer.tokenize(text)
    #   # all_words_without_stop_words = all_words.map { |word| "###" if stop_words.includes?(word) }
    #   # all_phrases = all_words_without_stop_words.join(" ").split("###")
    #   all_phrases = sentence_tokenizer.tokenize(text)
    #   word_frequency = Hash(String, Int32).new
    #   word_degree = Hash(String, Int32).new
    #   all_phrases.each do |phrase|
    #     word_list = word_tokenizer.tokenize(phrase)
    #     word_list_degree = (word_list.size) - 1
    #     word_list.each do |word|
    #       word_frequency.has_key?(word) ? (word_frequency[word] += 1) : (word_frequency[word] = 1)
    #       word_degree.has_key?(word) ? (word_degree[word] += word_list_degree) : (word_degree[word] = word_list_degree)
    #     end
    #   end
    #   word_frequency.keys.each do |word|
    #     word_degree[word] = word_degree[word] + word_frequency[word]
    #   end
    #   word_score = Hash(String, Float32).new
    #   word_frequency.keys.each do |word|
    #     word_score[word] = (word_degree[word] / word_frequency[word]).to_f32
    #   end
    #   keyword_candidates = Hash(String, Float32).new
    #   all_phrases.select! { |phrase| !phrase.blank? }
    #   all_phrases.each do |phrase|
    #     if all_phrases.count(phrase) >= minimum_frequency
    #       keyword_candidates[phrase] = 0.to_f32 if !keyword_candidates.has_key?(phrase)
    #       word_list = word_tokenizer.tokenize(phrase)
    #       candidate_score = 0
    #       word_list.each do |word|
    #         candidate_score += word_score[word]
    #       end
    #       keyword_candidates[phrase] = candidate_score.to_f32
    #     end
    #   end

    #   keyword_candidates.to_a.sort_by { |key, value| key }.to_h.keys
    # end
  end
end
