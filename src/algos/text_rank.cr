require "cadmium_tokenizer"
require "num"

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
      @word_tokenizer = Cadmium::Tokenizer::Aggressive.new


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

    #        less efficient algorithm kept for reference purposes
    # sentences_as_significant_terms.each_with_index do |words_i, i|
    #   sentences_as_significant_terms.each_with_index do |words_j, j|
    #     weights[i, j] = rate_sentences_edge(words_i, words_j)
    #   end
    # end

    weights = weights.column_vectors.map { |column| (column + @delta).normalize }
    Matrix.build(@number_of_sentences) { (1.0 - @damping) / @number_of_sentences } + weights.map { |weight| weight * @damping }
  end

      private def rate_words_edge(word_1 : String, word_2 : String) : Float64
        rank = 0
        return 0.0 if word_1 === word_2
   

        norm = Math.log(sentence_1.size) + Math.log(sentence_2.size)
        return rank * 1.0 if sentence_1.size + sentence_2.size == 2
        rank / norm
      end

      private def select_words(text : String, max_num_words = 5) : Array(String)
        return [""] unless text.size > 0 && max_num_sentences > 0
        matrix = create_matrix(text)
        ranks = power_method(matrix, @epsilon)
        ranked_words = text.tokenize(Tokenizer::Aggressive).zip(ranks).sort_by { |word_and_rating| word_and_rating[1] }
        ranked_words[..max_num_words - 1].map { |word_and_rating| word_and_rating[0] }
      end
    end
  end
end
