
require_relative 'config.rb'

require 'uci'

# TODO: Export def
def loadGame(path)
	game = Hash.new
	File.open(path, 'r').each do |s| 
		if s.start_with?('[')
			s = s.gsub(/(\[|\])/,'')
			game[s.split(/\s/).first] = s.scan(/"(.*?)"/).flatten.first
		end
	end
	game
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
	uci = Uci.new( :engine_path => Env[:engine_path] )
	while !uci.ready? do
	   puts "Engine isn't ready yet, sleeping..."
	   sleep(1)
	end
	puts "Engine is ready ^_^"
	# TODO
end