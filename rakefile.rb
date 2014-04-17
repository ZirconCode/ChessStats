
# Config...
puzzle_profile = 'http://chess.emrald.net/tProfile.php?TacID=70056'
chess_games = '/home/simon/.wine/drive_c/users/simon/My Documents/BabasChess/Games/'

player_name = "ZirconCode"
storage_games_path = 'games/'
storage_profile_path = 'puzzles/'

desc 'Grab chess.emrald Data'
task :update_puzzles do |t|
	require 'nokogiri'
	require 'open-uri'
	doc = Nokogiri::HTML(open(puzzle_profile))
	File.open(storage_profile_path+Time.now.to_i.to_s, "w") do |f|
		f.write doc.xpath('//td[@class=\'content\']')
	end
end

desc 'Grab Chess Games'
task :update_games do |t|
	files = FileList.new()
	files.include(chess_games+"*")
	FileUtils.cp(files,storage_games_path)
end

desc "Grab All Data"
multitask :update => [:update_puzzles, :update_games] do |t|
	# =)
end

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

desc "Interpret Data"
task :examine do |t|
	rating = []

	files = FileList.new()
	files.include(chess_games+"*")
	files.each do |f|
		g = loadGame(f)

		r = ''
		if(g['Black']=='ZirconCode')
			r = g['BlackElo']
		elsif(g['White']=='ZirconCode')
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

