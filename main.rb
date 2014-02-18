require 'csv'
require '~/work/Puzzle/restaurent'
require '~/work/Puzzle/puzzle'

#input file validations
if ARGV.count == 0
  puts"Please provide a valid file name"
  exit
else
  if !(ARGV[0] =~ /.csv/)
    puts "Please enter a valid menu in .csv format"
    exit
  else 
    if ARGV.count < 2
      puts "Please input atleast one item that you wish to eat"
      exit
    end
  end
end

#initialization
file_name = ARGV[0]
desired_items = ARGV[1..-1]

#processing
puzzle = Puzzle.new
puzzle.read_menu(file_name)
puzzle.init_max_price_hash
puzzle.get_available_restaurents(desired_items)
puzzle.get_optimized_price(desired_items)

