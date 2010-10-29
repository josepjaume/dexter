require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'dexter'

describe Dexter do
  describe 'self.load_files' do
    it "creates several instances of Video from an array" do
      list = [
        "dexter s01e02 HDTV.avi",
        "the.big.bang.theory.1x12.mkv",
        "the.big.bang.theory.1x12.sub",
        "the.big.bang.theory.1x12.srt"
      ]
      Dexter::Matchers::Video.should_receive(:new).exactly(2).times
      subject.load_files(list)
    end
  end

  describe 'self.organize!' do
    it "organizes all the files within a directory and subdirectories" do
      videos = (1..3).collect{Dexter::Matchers::Video.new('dexter s01e01.avi')}
      videos.each { |video|
        video.should_receive(:organize!).exactly(1).times
      }
      Dexter.should_receive(:load_from_directory)\
        .and_return(videos)

      File.should_receive(:file?).times.and_return(false)

      Dexter.organize!('.', '.')
    end
  end

  describe 'self.load_from_directory' do
    it "creates an instance of the corresponding type from every file" do
      Dexter.should_receive(:list_all_files_within_directory)\
        .and_return(["../family guy s04e08.avi","../fringe 1x18.mkv"])
      Dexter.load_from_directory('.').should have(2).videos
    end
  end

  describe 'self.list_all_files_within_directory' do
    it "gets a list of all files in a directory recursively" do
      Dir.should_receive(:glob).and_return(["../dexter s01e02 HDTV.avi", "../modern family 1x02.mkv"])
      Dexter.list_all_files_within_directory('/home/josepjaume').should == ["../dexter s01e02 HDTV.avi", "../modern family 1x02.mkv"]
    end

  end

  describe Dexter::Matchers do
    describe Dexter::Matchers::Video do
      subject{Dexter::Matchers::Video}
      describe 'self.allowed?' do
        it "returns true if the file is allowed" do
          subject.allowed?('dexter s01e01.avi').should be_true
        end
      end

      describe 'extension' do
        it "sorts the extension of a file out" do
          video = subject.new('dexter s01e01.avi')
          video.extension.should == 'avi'
        end
      end

      describe 'name' do
        it "returns the name of the tv series given a particular filename" do
          examples = {
            'the big bang theory - s01e09.avi' => 'The Big Bang Theory',
            'DEXTER S01E09.avi' => 'Dexter',
            'Family.Guy.S10E08.avi' => 'Family Guy'
          }
          examples.each do |key,value|
            video = subject.new('dexter s01e01.avi')
            video.stub(:filename).and_return(key)
            video.name.should == value
          end
        end
      end
      describe 'season' do
        it "returns the season when given a particular filename" do
          examples = {
            'the big bang theory - s01e09.avi' => 1,
            'DEXTER S05E09.avi' => 5,
            'Family.Guy.S10E08.avi' => 10,
            'The Show of cleveland - 1x2 .mkv' => 1
          }
          examples.each do |key,value|
            video = subject.new('dexter s01e01.avi')
            video.stub(:filename).and_return(key)
            video.season.should == value
          end
        end
      end
      describe 'episode' do
        it "returns the episode when given a particular filename" do
          examples = {
            'the big bang theory - s01e09.avi' => 9,
            'DEXTER S05E27.avi' => 27,
            'Family.Guy.S10E08.avi' => 8,
            'The Show of cleveland - 1x2 .mkv' => 2
          }
          examples.each do |key,value|
            video = subject.new('dexter s01e01.avi')
            video.stub(:filename).and_return(key)
            video.episode.should == value
          end
        end
      end
      describe "output" do
        it "should return the output path of the video" do
          video = Dexter::Matchers::Video.new('dexter s01e01.avi')
          video.should_receive(:season).and_return(1)
          video.should_receive(:episode).and_return(2)
          video.should_receive(:name).and_return("Modern Family")
          video.should_receive(:extension).and_return('avi')
          video.output(".").should == "./Modern Family/S01/Modern Family S01E02.avi"
        end
      end
      describe :organize! do
        it "should move the video to its corresponding path" do
          video = Dexter::Matchers::Video.new('dexter s01e01.avi')
          video.stub(:output).and_return('./Modern Family/S01/Modern Family S01E02.avi')
          video.stub(:filename).and_return('dexter s01e01.avi')
          FileUtils.should_receive(:mkdir_p).with('./Modern Family/S01')
          FileUtils.should_receive(:mv).with('dexter s01e01.avi','./Modern Family/S01/Modern Family S01E02.avi')
          video.organize!('./')
        end
      end
    end
  end
end
