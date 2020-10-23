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

    # class AbstractKeywordExtractor
    #   # word_tokenizer : Cadmium::Tokenizer::Aggressive = Cadmium::Tokenizer::Aggressive.new
    #   # sentence_tokenizer : Cadmium::Tokenizer::Sentence = Cadmium::Tokenizer::Sentence.new
    # end

    class TextRank < AbstractKeywordExtractor
      @damping = 0.85
      @epsilon = 1e-4
      @delta = 1e-7
      @number_of_sentences : Int32 = 1

      private def power_method(matrix : Tensor(Float64), epsilon = @epsilon) : Tensor(Float64)
        transposed_matrix = matrix.transpose
        p_vector = Tensor.from_array([1.0 / @number_of_sentences.to_f] * @number_of_sentences)
        lambda_val : Float64 = 1.0
        while lambda_val > epsilon
          temp_vec = p_vector
          transposed_matrix.column_vectors.each { |vector| temp_vec *= vector }
          next_p = temp_vec
          lambda_val = (next_p - p_vector).norm.not_nil!
          p_vector = next_p.not_nil!
        end

        p_vector.map { |element| element.to_f }
      end

      private def create_matrix(text : String) : Matrix(Float64)
        sentences_as_significant_terms = Document.new(text).sentences.map { |sentence| significant_terms(sentence.verbatim) }
        @number_of_sentences = sentences_as_significant_terms.size
        weights = Matrix.build(@number_of_sentences) { 0.0 }

        sentences_as_significant_terms.each_with_index do |words_i, i|
          sentences_as_significant_terms[i..].each_with_index do |words_j, j|
            weight = rate_sentences_edge(words_i, words_j)
            weights[i, j + i] = weight
            weights[j + i, i] = weight
          end
        end

        # less efficient algorithm kept for reference purposes
        # sentences_as_significant_terms.each_with_index do |words_i, i|
        #   sentences_as_significant_terms.each_with_index do |words_j, j|
        #     weights[i, j] = rate_sentences_edge(words_i, words_j)
        #   end
        # end

        weights = weights.column_vectors.map { |column| (column + @delta).normalize }
        Matrix.build(@number_of_sentences) { (1.0 - @damping) / @number_of_sentences } + weights.map { |weight| weight * @damping }
      end

      # See if we can assert that sentence_1.size and sentence_2.size > 0
      private def rate_sentences_edge(sentence_1 : Array(String), sentence_2 : Array(String)) : Float64
        rank = 0
        return 0.0 if sentence_1 === sentence_2
        sentence_1.each do |word_1|
          sentence_2.each do |word_2|
            rank = word_1 == word_2 ? rank + 1 : rank
          end
        end
        return 0.0 if rank == 0

        norm = Math.log(sentence_1.size) + Math.log(sentence_2.size)
        return rank * 1.0 if sentence_1.size + sentence_2.size == 2
        rank / norm
      end

      private def select_sentences(text : String, max_num_sentences = 5) : Array(String)
        return [""] unless text.size > 0 && max_num_sentences > 0
        matrix = create_matrix(text)
        ranks = power_method(matrix, @epsilon)
        ranked_sentences = text.tokenize(Tokenizer::Sentence).zip(ranks).sort_by { |sentence_and_rating| sentence_and_rating[1] }
        ranked_sentences[..max_num_sentences - 1].map { |sentence_and_rating| sentence_and_rating[0] }
      end
  end
end
