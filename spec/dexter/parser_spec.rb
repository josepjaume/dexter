require_relative '../spec_helper'
require 'dexter/parser'

describe "Parser" do
  subject{ Dexter::Parser.new }

  describe "rules" do
    describe :show do
      shows = [
        'Dexter', 'Modern Family', "Monty Python's Flying Circus",
        'true.blood', 'Louie'
      ]

      shows.each do |show|
        it "matches #{show}" do
          result = subject.show.parse(show)
          result[:show].must_equal show
        end
      end

      it "doesn't match the season" do
        begin
          subject.show.parse("The Walking Dead S01E02")
          subject[:show].must_equal "The Walking Dead"
        rescue Exception => e
          e.must_be_kind_of Parslet::ParseFailed
        end
      end
    end

    describe :episode_and_season do
      it "matches with letters" do
        result = subject.episode_and_season.parse("S05E06")
        result[:season].must_equal '05'
        result[:episode].must_equal '06'
      end
    end

    describe "single_file" do
      it "matches with dash" do
        string = "The Mentalist - S01E02"
        result = subject.single_file.parse(string)
        result[:show].to_s.must_equal "The Mentalist"
        result[:season].must_equal "01"
        result[:episode].must_equal "02"
      end

      it "matches with space" do
        string = "Louie S1E2"
        result = subject.single_file.parse(string)
        result[:show].to_s.must_equal "Louie"
        result[:season].must_equal "1"
        result[:episode].must_equal "2"
      end

      it "matches with dots" do
        string = "Arrested.Development.10x4"
        result = subject.single_file.parse(string)
        result[:show].to_s.must_equal "Arrested.Development"
        result[:season].must_equal "10"
        result[:episode].must_equal "4"
      end

      it "matches compressed" do
        string = "FamilyGuyS01E02"
        result = subject.single_file.parse(string)
        result[:show].to_s.must_equal "FamilyGuy"
        result[:season].must_equal "01"
        result[:episode].must_equal "02"
      end

      it "doesn't match without name" do
        string = "S01E02"
        Proc.new{
          subject.single_file.parse(string)
        }.must_raise Parslet::ParseFailed
      end

      it "doesn't match without season and episode" do
        string = "American Dad"
        Proc.new{
          subject.single_file.parse(string)
        }.must_raise Parslet::ParseFailed
      end
    end

    describe "path" do
      paths = {
        'Dexter/' => {show: 'Dexter'},
        'Modern Family/S01/' => {show: 'Modern Family', season: '01'},
        'Modern Family/5/' => {show: 'Modern Family', season: '5'},
        'Misfits/Season 2/' => {show: 'Misfits', season: '2'},
        'True Blood/season1/' => {show: 'True Blood', season: '1'}
      }
      paths.each do |path, data|
        describe path do
          data.each do |key, value|
            it "recognises #{key}" do
              result = subject.path.parse(path)
              result[key.to_sym].must_equal value
            end
          end
        end
      end
    end

    describe "resolution" do
      it "recognises 720p" do
        subject.resolution.parse("720p")[:resolution].
          must_equal "720"
      end

      it "recognises 1080p" do
        subject.resolution.parse("1080p")[:resolution].
          must_equal "1080"
      end

      it "recognises 480i" do
        subject.resolution.parse("480i")[:resolution].
          must_equal "480"
      end
    end
  end


  describe "integration" do
    stress =
      {
        'Dexter - S01E02' => {
          show: 'Dexter', season: '01', episode: '02'
        },
        'Dexter - 1x02' => {
          show: 'Dexter', season: '1', episode: '02'
        },
        'Modern Family - S11E02.mkv' => {
          show: 'Modern Family', season: '11', episode: '02', extension: 'mkv'
        },
        'Louie/Louie - 1x2.avi' => {
          show: 'Louie', season: '1', episode: '2', extension: 'avi'
        },
        'Family.Guy.S01E07.720p.HDTV.X264-DIMENSION.mkv' => {
          show: 'Family.Guy', season: '01', episode: '07', resolution: '720',
          extension: 'mkv'
        },
        'Sample/Family.Guy.S01E07.720p.HDTV.X264-DIMENSION.mkv' => {
          show: 'Family.Guy', season: '01', episode: '07', resolution: '720',
          extension: 'mkv', sample: 'Sample'
        },
        'Misfits/S01/1.avi' => {
          show: 'Misfits', season: '01', episode: '1'
        },
        "Monty Python's Flying Circus/Season 3/04 - The bicycle tour.mkv" => {
          show: "Monty Python's Flying Circus",
          season: '3',
          episode: '04'
        }

      }

    stress.each do |string, matches|
      describe string do
        matches.each do |key, value|
          it "detects the #{key}" do
            result = subject.parse(string)
            result[key.to_sym].to_s.must_equal value
          end
        end
      end
    end
  end
end
