# This program allows a user to play Tic-Tac-Toe against the computer
# where the computer will either win or draw.

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

class TicTacToeGame

  def initialize
    @open_spots = [0, 1, 2,
                   3, 4, 5,
                   6, 7, 8]

    @corners = [0, 2, 6, 8]
    @opponent = []
    @computer = []
    @occupied = []
    @game_on = true
  end

  def play
    welcome
    while @game_on
      render_board
      player_move
      clear_screen
      status
      computer_move    
      status 
    end
  end

  def clear_screen
    print "\033[2J"
  end

  def welcome
    clear_screen
    print "\x1b[33m"
    print "\n"
    puts "*********" * 6
    print "\n"
    puts "Welcome to Tic Tac Toe!"
    puts "Your moves will be marked with an X."
    puts "The computer's moves will be marked with an 0."
    puts "Type help for menu and options."
    puts "Good luck!"
    print "\n"
  end

  def show_menu
    print "\n"
    puts "> Your options are"
    puts "> type q to quit"
    puts "> or select an open square:"
    puts "> #{@open_spots}"

  end

  def status
    game_over?
    draw?
  end

  def draw?
    if @open_spots.empty?
      puts "It's a draw!"
      print "\n"
      render_board
      print "\x1b[0m"
      Process.exit
    end
  end

  def update_board move
    @occupied << move
    @open_spots.delete(move)
    @corners.delete(move) if @corners.include?(move)
  end

  def render_board
    board = ['-'] * 9
    @computer.each { |element| board[element] = 'O' } 
    @opponent.each { |element| board[element] = 'X' } 

    i = 0
    3.times do
      print " #{board[i]} | #{board[i+1]} | #{board[i+2]}\n"
      puts  " _________ "
      i += 3
    end
    print "\n"
  end

  def player_move
    turn = true
    while turn
      puts "> These are the open spots: #{@open_spots}"
      print "> Which do you choose? "
      
      player_move = gets.chomp

      if player_move == 'q'
        puts "Exiting game"
        print "\x1b[0m"
        Process.exit
      elsif player_move == 'help'
        show_menu
      elsif @open_spots.include?(player_move.to_i)
        player_move = player_move.to_i
        turn = false
        @opponent << player_move
        @opponent.sort!
        update_board player_move 
      else
        puts "> pick a spot between 0 and 8 that's open"
        print "\n"
      end
    end
  end

  def computer_move
    move = nil
    move = take_center
    move = try_win if !move
    move = block_opponent if !move
    move = take_corner if !move
    move = default if !move
  end

  def take_center
    return nil if !@open_spots.include?(4)
    move = 4
    update_board move
    @computer << move    
    @computer.sort!
    move
  end

  def try_win
    return nil if @computer.length < 2
   
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
        
        value.each do |element|
          next if @computer.include?(element)
          @computer << element
          @computer.sort!
          update_board element
          return element
        end
      end
    end
    return nil
  end

  def block_opponent
   
    check_hands
  end

  def default
    @open_spots.sample
  end

  def game_over?
    WINNING_HANDS.each do |key, value|
      counter = 0
      value.each do |element|
        if @opponent.include?(element)
          counter += 1
          if counter == 3
            puts "Opponent is the winner!"
            print "\n"
            render_board
            print "\x1b[0m"
            Process.exit
          end
        end
      end
      
      counter = 0
      value.each do |element|
        if @computer.include?(element)
          counter += 1
          if counter == 3
            puts "Computer is the winner!"
            print "\n"
            render_board
            print "\x1b[0m"
            Process.exit
          end
        end
      end
    end
  end

  def take_corner
    return if @corners.empty?
    move = @corners.sample
    update_board move
    @computer << move
    @computer.sort!
    return move
  end

  def take_open_spot
    move = @open_spots.sample
    @computer << move
    update_board move
    puts @computer
    @computer.sort!
  end


  def block hand, winning_row
    WINNING_HANDS[hand].each do |element|
      if !winning_row.include?(element) && !@occupied.include?(element)
        move = element
        update_board element
        @computer << move
        @computer.sort!
        return move
      end
    end
  end

  def check_hands
    
    return if @opponent.length < 2
    WINNING_HANDS.each do |hand, value|
      winning_row_count = 0
      winning_row = []

      value.each do |element|
        if @opponent.include?(element)
          winning_row_count += 1
          winning_row << element
        elsif @computer.include?(element)
          winning_row_count -= 1
        end
      end

      if winning_row_count == 2
        return block(hand, winning_row)
      end
    end 
    return nil
  end 
end 

game1 = TicTacToeGame.new
game1.play
