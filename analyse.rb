
require_relative 'config.rb'

require 'uci'

# .pgn Files (ex. from BabasChess)
def loadGame(path)
	game = Hash.new
	rest = '' 
	File.open(path, 'r').each do |s| 
		if s.start_with?('[')
			s = s.gsub(/(\[|\])/,'')
			game[s.split(/\s/).first] = s.scan(/"(.*?)"/).flatten.first
		else
			rest += s
		end
	end

	rest.gsub!(%r<{.*?}>,'') # remove comments
	rest.delete!("\n")
	#rest.delete!("\t")

	moves = rest.scan(/\d\.+\s(.+?)\s(.+?)\s/).to_a.flatten
	moves.map!{|s| s.strip}
	moves.reject! { |c| c.empty? }
	game['moves'] = moves

	game
end

def shortToLong(shorthand,board)

end

def examine
	rating = []

	files = FileList.new()
	files.include(Env[:chess_games]+"*")
	files.each do |f|
		g = loadGame(f)

		r = ''
		if(g['Black']==Env[:player_name])
			r = g['BlackElo']
		elsif(g['White']==Env[:player_name])
			r = g['WhiteElo']
		end

		if(!g['Date'].include?('?') && g['Event']=='rated standard match')
			rating << g['Date']+' '+r
			# TODO
		end
		
	end

	# TODO -> d3
	puts rating
end

def runStockfish
	g = loadGame(Env[:chess_games]+'/-_20140421_mhead.pgn')

	uci = Uci.new(:engine_path => Env[:engine_path], :movetime => 100)
	while !uci.ready? do
		puts "Engine isn't ready yet, sleeping..."
		sleep(1)
	end
	puts "Engine is ready ^_^"

	interesting = []
	g['moves'].each do |m|
		puts m
		cmd = shortToLong(m)
		puts cmd
		uci.move_piece(m) # TODO doesn't take shorthand
	end

	puts uci.board
	puts uci.fenstring
end