require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    range = [*('a'..'z')]
    @letters = []
    10.times do
      @letters << range.sample
    end
    return @letters
  end

  def score
    @submission = params[:word]
    @letters = params[:letters]
    @display = ''

    if !valid_letters?(@submission, @letters)
      @display = "Sorry but '#{@submission}' can't be built out of #{@letters.split.join(", ")}."

    elsif !is_english?(@submission.downcase)
      @display = "Sorry, '#{@submission}' does not seem to be an English word."
    else
      @total_score = session[:total_score].nil? ? 0 : session[:total_score]
      @total_score += @submission.length * 10
      session[:total_score] = @total_score
      @display = "Congrats, you got a word: #{@submission} \n Your total score is #{@total_score}"
    end
  end

  private

  def valid_letters?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def is_english?(word)
    return JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{word}").read)["found"]
  end

  def calculate(word)
    word.length * 10
  end
end