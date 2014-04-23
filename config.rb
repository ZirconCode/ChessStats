
# Bundler
require 'rubygems'
require 'bundler/setup'

# Config...
Env = Hash.new
Env[:puzzle_profile] = 'http://chess.emrald.net/tProfile.php?TacID=70056'
Env[:chess_games] = '/home/simon/.wine/drive_c/users/simon/My Documents/BabasChess/Games/'

Env[:player_name] = "ZirconCode"
Env[:storage_games_path] = 'games/'
Env[:storage_profile_path] = 'puzzles/'

