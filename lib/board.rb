# frozen_string_literal: true

# contains all pieces and methods to return data about
# the pieces on the board
class Board
  def initialize
    @game_board = Array.new(8) { Array.new(8) { "\s" * 3 } }
    set_up_pawns
    @game_board[0] = back_row('black', 0)
    @game_board[7] = back_row('white', 7)
  end

  def play_game
    open_game?
    player_turn = 'white'
    loop do
      player_turn = player_turn == 'white' ? 'black' : 'white'
      if check_mate?(player_turn)
        red_output('check mate')
        break
      end
      check_prompt(player_turn) if check?(player_turn)
      if stale_mate(player_turn)
        red_output('stale mate')
        break
      end
      player_turn(player_turn)
      break if save_game?
      system 'clear'
    end
  end

  private

  def save_game?
    red_output("would you like to save this game?")
    red_output("type s to save")
    red_output("just press enter to continue")
    input = gets.chomp
    if input.match(/s/)
      save_game
      true
    else
      false
    end
  end

  def open_game?
    red_output("would you like to open a saved game?\n")
    red_output("press enter to create a new game\nor type yes to open a saved game\n")
    if gets.chomp.match?(/yes/)
      display_games
      red_output("enter the number of the game you would like to open\n")
      game_number = input_valid_game_number
      open_saved_game(game_number)
    end
  end

  def input_valid_game_number
    valid_numbers = saved_game_numbers
    input = gets.chomp.to_i
    if valid_numbers.include?(input)
      return input
    else
      red_output("that is not a game number")
      return input_valid_game_number
    end
  end

  def save_game
    Dir.mkdir('./saved_games') unless Dir.exist?('./saved_games')
    file_number = 0
    while File.exist?("./saved_games/game_#{file_number}.game")
      file_number += 1
    end
    File.open("./saved_games/game_#{file_number}.game", 'w') do |file|
      file.write(Marshal.dump(@game_board))
    end
  end

  def open_saved_game(game_number)
    if File.exist?("./saved_games/game_#{game_number}.game")
      File.open("./saved_games/game_#{game_number}.game", 'r') do |file|
        @game_board = Marshal.load(file.read)
      end  
      true
    else
      false
    end
  end

  def saved_game_numbers
    saved_game_numbers = []
    if Dir.exist?('./saved_games')
      file_number = 0
      Dir.each_child('./saved_games') do |file_name|
        saved_game_numbers << file_name.match(/game_(.+).game/)[1].to_i
      end
    end
    saved_game_numbers
  end

  def display_games
    original_board = Marshal.dump(@game_board)
    if Dir.exist?('./saved_games')
      file_number = 0
      Dir.each_child('./saved_games') do |file_name|
        red_output(file_name)
        File.open("./saved_games/#{file_name}") do |file|
          @game_board = Marshal.load(file.read)
          display_board
          @game_board = original_board
          original_board = Marshal.dump(@board)
        end
      end
    end
  end

  def check_prompt(color)
    moves_out_of_check = possible_moves_out_of_check(color)
    red_output("There are #{moves_out_of_check.size} possible ways for you to get out of check")
    selected_piece = select_piece(color)
    if moves_out_of_check[selected_piece.value].nil?
      red_output('Moving that piece will not get you out of check')
      check_prompt(color)
    else
      color_array = default_color_array
      selected_piece_value = selected_piece.value
      moves_out_of_check[selected_piece_value].map(&:value).each do |position|
        color_array[position[1]][position[0]] = :green
      end
      color_array[selected_piece_value[1]][selected_piece_value[0]] = :blue
      display_board(color_array)
      select_position_to_move(selected_piece, moves_out_of_check[selected_piece_value])
    end
  end

  def possible_moves_out_of_check(color)
    piece_position_non_check_moves = {}
    unchanged_board = Marshal.load(Marshal.dump(@game_board))
    player_positions = all_player_positions(color)
    player_positions.each { |position| piece_position_non_check_moves[position.value] = [] }
    player_positions.each do |player_position|
      position_possible_moves = possible_moves(player_position)
      position_possible_moves.each do |possible_move|
        make_move(player_position, possible_move)
        unless check?(color)
          piece_position_non_check_moves[player_position.value] << possible_move
        end
        @game_board = unchanged_board
        unchanged_board = Marshal.load(Marshal.dump(@game_board))
      end
    end
    piece_position_non_check_moves.reject { |_player_position, possible_moves| possible_moves.empty? }
  end

  def stale_mate(color)
    all_possible_moves(color).empty? && !check(color)
  end

  def check_mate?(color)
    check?(color) && king_possible_moves(color).empty?
  end

  def king_possible_moves(color)
    king_position = find_king(color)
    king_possible_moves = possible_moves(king_position)
    opponent_color = opponent_color(color)
    opponent_possible_moves = all_possible_moves(opponent_color)
    king_possible_moves.reject do |king_move|
      opponent_possible_moves.include?(king_move.value)
    end
  end

  def opponent_color(player_color)
    player_color == 'black' ? 'white' : 'black'
  end

  def check?(player_color)
    opponent_color = player_color == 'black' ? 'white' : 'black'
    king_position = find_king(player_color).value
    opponent_possible_moves = all_possible_moves(opponent_color)
    opponent_possible_moves.include?(king_position)
  end

  def all_possible_moves(color)
    player_positions = all_player_positions(color)
    possible_moves = player_positions.map do |position|
      possible_moves(position).map(&:value)
    end.flatten(1).uniq
  end

  def all_player_positions(color)
    player_positions = @game_board.flatten.select do |value|
      value.class != String && value.color ==  color
    end.map(&:position)
  end

  def find_king(color)
    @game_board.flatten.find do |piece|
      piece.class == King && piece.color == color
    end.position
  end

  def player_turn(player_color)
    system 'clear'
    red_output("#{player_color}'s turn")
    display_board
    position = select_piece(player_color)
    system 'clear'
    display_possible_moves(position)
    position_to_move = select_position_to_move(position)
    make_move(position, position_to_move)
    system 'clear'
    display_board
  end

  def select_piece(player_color)
    print "\nenter the coordinate of the piece\nthat you would like to move.\n"
    print "in the format number,number\n"
    print "eg. 5,1\n"
    user_input = gets.chomp.match(/(\d),(\d)/)
    if user_input.nil?
      red_output("invalid input\n")
      return select_piece(player_color)
    end
    position = Position.new(user_input.captures.map(&:to_i))
    unless on_board?(position)
      red_output("That piece is not on the board\n")
      return select_piece(player_color)
    end
    if position_empty(position)
      red_output("There is no piece in that position\n")
      return select_piece(player_color)
    end
    unless player_piece?(player_color, position)
      red_output("This piece is not yours\n")
      return select_piece(player_color)
    end
    unless piece_moveable?(position)
      red_output("This piece cannot move anywhere\n")
      return select_piece(player_color)
    end
    position
  end

  def red_output(string)
    print ColorizedString[string].colorize(color: :red)
  end

  def universal_possible_moves(piece_position)
    piece = position_to_value(piece_position)
    piece.class == King ? king_possible_moves(piece.color) : possible_moves(piece_position)
  end

  def select_position_to_move(piece_position, possible_moves = nil)
    print "\nenter the coordinate you would like to move this piece\n"
    print "in the format number,number\n"
    print "eg. 5,1\n"
    if possible_moves.nil?
      possible_moves = universal_possible_moves(piece_position)
    end
    user_input = gets.chomp.match(/(\d),(\d)/)
    if user_input.nil?
      red_output("invalid input\n")
      return select_position_to_move(piece_position)
    end
    selected_position = user_input.captures.map(&:to_i)
    unless possible_moves.any? { |position| position.value == selected_position }
      red_output('That is not a possible move')
      return select_position_to_move(piece_position)
    end
    Position.new(selected_position)
  end

  def piece_moveable?(position)
    !universal_possible_moves(position).empty?
  end

  def position_empty(position)
    position_to_value(position) == "\s" * 3
  end

  def player_piece?(color, position)
    position_value = position.value
    piece = @game_board[position_value[1]][position_value[0]]
    piece.color == color
  end

  def player_positions(color)
    @game_board.map do |row|
      row.select do |position|
        position != "\s" * 3 && position.color == color
      end.map(&:position)
    end.flatten
  end

  def make_move(position_of_piece, position_to_move)
    piece = position_to_value(position_of_piece)
    piece.position = position_to_move
    start_position_value = position_of_piece.value
    end_position_value = position_to_move.value
    @game_board[end_position_value[1]][end_position_value[0]] = piece
    @game_board[start_position_value[1]][start_position_value[0]] = "\s" * 3
  end

  def default_color_array
    color_array = Array.new(8) do |row_i|
      Array.new(8) do |piece_i|
        (row_i + piece_i).even? ? :red : :light_black
      end
    end
  end

  def display_possible_moves(piece_position)
    possible_moves = universal_possible_moves(piece_position)
    color_array = default_color_array
    position_value = piece_position.value
    color_array[position_value[1]][position_value[0]] = :blue
    possible_moves.each do |possible_move|
      move_position = possible_move.value
      color_array[move_position[1]][move_position[0]] = :green
    end
    display_board(color_array)
  end

  def display_board(color_array = default_color_array)
    print "\n"
    top_index = ("\s" * 2) + (0..7).to_a.map { |num| num.to_s.center(3) }.join + "\n"
    board = @game_board.map.with_index do |row, row_index|
      "#{row_index}\s" + row.map.with_index do |piece, piece_index|
        color = color_array[row_index][piece_index]
        ColorizedString[piece.to_s].colorize(background: color.to_sym)
      end.join + "\n"
    end.join
    print top_index + board
  end

  def possible_moves(piece_position)
    piece = position_to_value(piece_position)
    player_color = piece.color
    behaviors = piece.behaviors
    possible_moves = []
    behaviors.each do |behavior|
      next unless test_start_condition(behavior[:start_condition], piece)

      behavior[:directions].each do |direction|
        iterator = 0
        position = piece_position
        loop do
          if !behavior[:iterations].nil? && iterator == behavior[:iterations]
            break
          end

          position = direction.split(' ').inject(position) do |new_position, next_direction|
            new_position.method(next_direction.to_sym).call
          end
          break unless on_board?(position)

          value = position_to_value(position)
          if empty_space?(value)
            possible_moves << position
          elsif my_piece?(value, player_color)
            break
          elsif behavior[:take_opponent]
            possible_moves << position
            break
          else
            break
          end
          iterator += 1
        end
      end
    end
    possible_moves
  end

  def test_start_condition(start_condition, piece)
    return true if start_condition == 'none'

    player_color = piece.color
    split_condition = start_condition.split(' ')
    case split_condition[0]
    when 'self_on'
      if split_condition[1] == 'front_line'

        player_front_line = player_color == 'white' ? 6 : 1
        return piece.position.value[1] == player_front_line
      end
    when 'opponent_on'
      direction = split_condition[1]
      possible_opponent_position = piece.position.method(direction.to_sym).call
      value_of_position = position_to_value(possible_opponent_position)
      return false unless on_board?(possible_opponent_position)
      return opponent_piece?(value_of_position, player_color)
    end
  end

  def empty_space?(value)
    value == "\s" * 3
  end

  def my_piece?(value, player_color)
    !empty_space?(value) && value.color == player_color
  end

  def opponent_piece?(value, player_color)
    !empty_space?(value) && value.color != player_color
  end

  def on_board?(position)
    coordinate = position.value
    coordinate.all? { |linear_position| (0..7).include?(linear_position) }
  end

  def position_to_value(position)
    coordinate = position.value
    @game_board[coordinate[1]][coordinate[0]]
  end

  def set_up_pawns
    @game_board[1] = Array.new(8) do |x_index|
      Pawn.new([x_index, 1], 'black')
    end
    @game_board[6] = Array.new(8) do |x_index|
      Pawn.new([x_index, 6], 'white')
    end
  end

  def back_row(color, row)
    positions = [Rook, Knight, Bishop,
                 Queen, King, Bishop, Knight, Rook]
    Array.new(8) do |x_index|
      positions[x_index].new([x_index, row], color)
    end
  end
end
