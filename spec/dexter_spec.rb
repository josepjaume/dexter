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
      Dexter::Matchers::Subtitle.should_receive(:new).exactly(2).times
      subject.load_files(list)
    end
  end

  describe Dexter::FileUtils do
    describe 'self.extension' do
      it "sorts the extension of a file out" do
        @filename = "dexter s01e02.avi"
        Dexter::FileUtils.extension(@filename) \
          .should == 'avi'
      end
    end
    describe 'self.list_all_files_within_directory' do
      it "gets a list of all files in a directory recursively" do
        Dexter::FileUtils.list_all_files_within_directory('/home/josepjaume')
      end
    end
  end

  describe Dexter::Matchers do
    describe Dexter::Matchers::Video do
      subject{Dexter::Matchers::Video}
      describe 'self.allowed?' do
        it "returns true if the file is allowed" do
          subject.allowed?('hola.avi').should be_true
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
            video = subject.new('foo.avi')
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
            video = subject.new('foo.avi')
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
            video = subject.new('foo.avi')
            video.stub(:filename).and_return(key)
            video.episode.should == value
          end
        end
      end
    end
  end
end
