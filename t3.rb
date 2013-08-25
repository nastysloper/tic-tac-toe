# To win at Tic Tac Toe, a player must occupy three spaces in a "row"
# Rows are defined as follows:

require 'pry'

WINNING_HANDS = {

  # horizontal winning hands
  :hand1 => [0,1,2],
  :hand2 => [3,4,5],
  :hand3 => [6,7,8],

  # vertical winning hands
  :hand4 => [0,3,6],
  :hand5 => [1,4,7],
  :hand6 => [2,5,8],

  # diagonal winning hands
  :hand7 => [0,4,8],
  :hand8 => [2,4,6]
}

OPEN_SPOTS = [0, 1, 2,
              3, 4, 5,
              6, 7, 8]

CORNERS = [0, 2, 6, 8]

class TicTacGame
  attr_reader :opponent, :computer

  def initialize
    @opponent = []
    @computer = []
    @occupied = []
    @game_on = true
    @turn = false
  end

  def play
    while @game_on
      if OPEN_SPOTS.empty?
        puts "It's a draw!"
        @game_on = false 
      end

      player_move
      show_game 

      puts "It's the computer's turn"

      computer_move
      show_game 
    end
  end

  def player_move # This method is finished, ready to be refactored.
    flag = true
    while flag 
      puts "What's your move?"
      player_move = gets.chomp

      if player_move == 'q'
        @game_on = false
        flag = false
      elsif OPEN_SPOTS.include?(player_move.to_i)
        player_move = player_move.to_i
        flag = false
        @opponent << player_move
        @occupied << player_move
        OPEN_SPOTS.delete(player_move)
        CORNERS.delete(player_move) if CORNERS.include?(player_move)
        @opponent.sort! 
        return  
      else
        puts "pick a spot between 0 and 8"
        puts "these are taken: #{@occupied}"
      end
    end
  end

  def computer_move
    @turn = true

    while @turn
      if @computer.length == 2 
        try_win
        @turn = false
      elsif OPEN_SPOTS.include?(4)
        move = 4
        OPEN_SPOTS.delete(move)
        @occupied << move
        @computer << move  
        
        @computer.sort!
        @turn = false
      elsif @opponent.length == 1
        puts "take a corner!"
        take_corner
        @turn = false
      else
        puts "let's check hands"
        check_hands
        @turn = false
      end
    end
  end


  def try_win
    puts "trying for a win"
    WINNING_HANDS.each do |hand, value|
      winning_row = 0
      value.each do |element|
        if @computer.include?(element)
          winning_row += 1
        elsif @opponent.include?(element)
          winning_row -= 1
        end
      end

      if winning_row == 2
        puts "going for it!"
        value.each do |element|
          next if @computer.include?(element)
          @computer << element
          puts @computer
          @computer.sort!
          @occupied << element
          return
        end
      end
    end
    check_hands 
  end


  def show_game
    puts "Opponent has #{@opponent}"
    puts "Computer has #{@computer}"
    game_over?
  end

  def game_over? # check to see if there's a winner
    WINNING_HANDS.each do |key, value|
      counter = 0
      value.each do |element|
        if @opponent.include?(element)
          counter += 1
          if counter == 3
            puts "opponent is the winner!"
            @game_on = false
          end
        end
      end
      
      counter = 0
      value.each do |element|
        if @computer.include?(element)
          counter += 1
          if counter == 3
            puts "Computer is the winner!"
            @game_on = false
          end
        end
      end
    end
  end

  def take_corner # called from computer move
    if CORNERS.length == 0
      take_middle
    else
      puts "In take corner"
      move = CORNERS.sample
      OPEN_SPOTS.delete(move)
      CORNERS.delete(move)
      @occupied << move
      @computer << move
      puts @computer
      @computer.sort!
    end
  end

  def take_open_spot
    puts "In take an open spot..."
    move = OPEN_SPOTS.sample
    @computer << move
    @occupied << move
    puts @computer
    @computer.sort!
    OPEN_SPOTS.delete(move)
    CORNERS.delete(move) if CORNERS.include?(move)
  end


  def block hand, winning_row
    puts "In block"
    turn = 0
    WINNING_HANDS[hand].each do |element|
      if !winning_row.include?(element) && !@occupied.include?(element)
        move = element
        OPEN_SPOTS.delete(element)
        CORNERS.delete(move) if CORNERS.include?(move)
        turn = 1
        return element
      end
    end
    if turn == 0
      take_corner
    end
  end

  def check_hands
    
    WINNING_HANDS.each do |hand, value|
      winning_row_count = 0
      winning_row = [] # this will track a row that might be a winner

      value.each do |element| # and then iterate over the values in each key.
        if @opponent.include?(element)
          winning_row_count += 1
          winning_row << element
          if @computer.include?(element)
            winning_row_count -= 1
          end
        end
      end

      if winning_row_count == 2
        puts "Opponent is in position to win!"
          move = block(hand, winning_row)
          @computer << move
          @occupied << move
          puts @computer
          return
      end
    end 

    # if we're here, that means there are no 2 out of three hands.
    
      # puts "No 2 out of three?"
      # move = OPEN_SPOTS.sample
      # @computer << move
      # @occupied << move
      # puts @computer
      # OPEN_SPOTS.delete(move)
      # CORNERS.delete(move) if CORNERS.include?(move)
    
  end 

  def remove_from_list
  end

  def taken?
    return true
  end

end 

game1 = TicTacGame.new
game1.play
