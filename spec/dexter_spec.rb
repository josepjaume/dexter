require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'dexter'

describe Dexter do
  describe 'self.load_files' do
    it "creates several instances of Video from an array" do
      list = [
        "dexter s01e02 HDTV.avi",
        "the.big.bang.theory.1x12.mkv"
      ]
      Dexter::Matchers::Video.should_receive(:new).exactly(list.count).times
      subject.load_files(list)
    end
  end

  describe Dexter::AbstractMatcher do
    describe 'extension' do
      subject{Dexter::AbstractMatcher}
      it "sorts out the extension of the associated file" do
        @filename = "dexter s01e02 HDTV.avi"
        subject.new(@filename).extension.should == 'avi'
      end
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
  end

  describe Dexter::Matchers do
    describe Dexter::Matchers::Video do
      subject{Dexter::Matchers::Video}
      describe 'self.allowed?' do
        it "returns true if the file is allowed" do
          subject.allowed?('hola.avi').should be_true
        end
      end
    end
  end
end
