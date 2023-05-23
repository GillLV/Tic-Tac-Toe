# frozen_string_literal: false

# Resonsible for drawing the baord and it's pieces
class Board
  attr_reader :board

  def initialize
    @empty_board = "  A   B   C \n" \
                   "1   |   |   \n" \
                   " -----------\n" \
                   "2   |   |   \n" \
                   " -----------\n" \
                   "3   |   |   \n"
    @board = @empty_board

    @squares = { A1: 15, B1: 19, C1: 23, A2: 41, B2: 45, C2: 49, A3: 67, B3: 71, C3: 75 }
  end

  def insert(piece, square)
    @board[@squares[square]] = piece
  end

  def square_free?(square)
    @board[@squares[square]] != 'X' && @board[@squares[square]] != 'O'
  end

  def clear_board
    @board = @empty_board
  end

  def check_for_winner(piece)
    check_rows(piece) || check_columns(piece) || check_diagonals(piece)
  end

  def check_rows(piece)
    check_row1(piece) || check_row2(piece) || check_row3(piece)
  end

  def check_columns(piece)
    check_column1(piece) || check_column2(piece) || check_column3(piece)
  end

  def check_diagonals(piece)
    check_diagonal_a1(piece) || check_diagonal_a3(piece)
  end

  def check_row1(piece)
    @board[@squares[:A1]] == piece && @board[@squares[:B1]] == piece && @board[@squares[:C1]] == piece
  end

  def check_row2(piece)
    @board[@squares[:A2]] == piece && @board[@squares[:B2]] == piece && @board[@squares[:C2]] == piece
  end

  def check_row3(piece)
    @board[@squares[:A3]] == piece && @board[@squares[:B3]] == piece && @board[@squares[:C3]] == piece
  end

  def check_column1(piece)
    @board[@squares[:A1]] == piece && @board[@squares[:A2]] == piece && @board[@squares[:A3]] == piece
  end

  def check_column2(piece)
    @board[@squares[:B1]] == piece && @board[@squares[:B2]] == piece && @board[@squares[:B3]] == piece
  end

  def check_column3(piece)
    @board[@squares[:C1]] == piece && @board[@squares[:C2]] == piece && @board[@squares[:C3]] == piece
  end

  def check_diagonal_a1(piece)
    @board[@squares[:A1]] == piece && @board[@squares[:B2]] == piece && @board[@squares[:C3]] == piece
  end

  def check_diagonal_a3(piece)
    @board[@squares[:A3]] == piece && @board[@squares[:B2]] == piece && @board[@squares[:C1]] == piece
  end
end

# Defines the logic controlling the player's responsibilities
class Player
  attr_reader :piece, :name

  def initialize(board, piece, name)
    @board = board
    @piece = piece
    @name = name
  end

  def insert_square?(square)
    square.upcase!
    sym = square.to_sym
    if @board.square_free?(sym)
       @board.insert(@piece, sym)
       return true
    end
    false
  end

  def valid_square?(square)
    valid_squares = %w[A1 A2 A3 B1 B2 B3 C1 C2 C3]
    valid_squares.each do |sqr|
      if square.casecmp(sqr).zero?
        return insert_square?(square)
      end
    end
    false
  end

  def choose_square(name)
    loop do
      puts "#{name} choose a square (eg. A1)\n"
      square = gets.chomp
      break if valid_square?(square)

      puts "That's not a vaild square. Please choose again\n"
    end
  end

  def winner?(piece)
    @board.check_for_winner(piece)
  end
end

board = Board.new
player1 = Player.new(board, 'X', 'Player1')
player2 = Player.new(board, 'O', 'Player2')
winner = ''
NUM_ROUNDS = 5

puts board.board

(1..NUM_ROUNDS).each do |i|
  player1.choose_square(player1.name)
  puts board.board
  if player1.winner?(player1.piece)
    winner = player1.name
    break
  end
  break if i == NUM_ROUNDS

  player2.choose_square(player2.name)
  puts board.board
  if player2.winner?(player2.piece)
    winner = player2.name
    break
  end
end

if winner != ''
  puts "Congradulations #{winner}, you have won! \n"
else
  puts "It's a tie! try again!\n"
end
