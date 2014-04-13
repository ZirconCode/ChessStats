
# Config...
puzzle_profile = 'http://chess.emrald.net/tProfile.php?TacID=70056'
chess_games = '/home/simon/.wine/drive_c/users/simon/My Documents/BabasChess/Games/'


desc 'Grab chess.emrald Data'
task :update_puzzles do |t|
	require 'nokogiri'
	require 'open-uri'
	doc = Nokogiri::HTML(open(puzzle_profile))
	File.open('puzzles/'+Time.now.to_i.to_s, "w") do |f|
		f.write doc.xpath('//td[@class=\'content\']')
	end
end

desc 'Grab Chess Games'
task :update_games do |t|
	files = FileList.new()
	files.include(chess_games+"*")
	FileUtils.cp(files,'games/')
end

desc "Grab All Data"
multitask :update => [:update_puzzles, :update_games] do |t|
	# =)
end

