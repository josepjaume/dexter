require_relative '../../spec_helper'
require 'dexter/renamer'

require 'mocha'
require 'fakefs'

describe "Parser" do
  let(:filename) do
    'Family.Guy.S01E07.720p.HDTV.X264-DIMENSION.mkv'
  end

  subject do
    Dexter::Renamer::File.new(filename)
  end

  let(:filename) do
    "Dexter - S01E02.mkv"
  end

  let(:fake_episode) do
    Dexter::Detective::Episode.new({
      show: 'Dexter',
      season: 1,
      episode: 2,
      extension: 'mkv'
    })
  end

  describe "destination_filename" do
    after do
      Dexter.configure do |config|
        config.reset_format
      end
    end

    it "sets a default format" do
      subject.destination_filename.
        must_equal "Dexter/S01/Dexter - S01E02.mkv"
    end

    it "uses a format from the configuration" do
      Dexter.config.format do
        "#{show} #{episode}x#{season}.#{extension}"
      end
      subject.destination_filename.
        must_equal "Dexter 2x1.mkv"
    end
  end

  describe "basedir" do

    after do
      Dexter.config.basedir = nil
    end

    it "uses current dir as default" do
      subject.basedir.must_equal File.expand_path('.')
    end

    it "uses the dir defined in the config if provided" do
      Dexter.config.basedir = "~"
      subject.basedir.must_equal File.expand_path('~')
    end
  end

  describe "destination" do
    it "mixes the basedir and destination_filename" do
      subject.stubs(basedir: '/home')
      subject.stubs(destination_filename: 'fake.txt')
      subject.destination.must_equal '/home/fake.txt'
    end
  end

  describe "file operations" do
    after do
      FakeFS::FileSystem.clear
    end

    describe "create_folder" do
      it "creates the folder if it doesn't exist" do
        subject.create_dir
        File.exists?(
          File.expand_path("Dexter/S01")
        ).must_equal true
      end

      it "does nothing if the folder if exists" do
        FileUtils.mkdir_p("Dexter/S01")
        subject.create_dir
      end
    end

    describe "destination_exists?" do

      it "returns true if the destination already exists" do
        File.open('destination', 'w'){|f| f.write("DESTINATION")}
        subject.stubs(destination: File.expand_path("destination"))
        subject.destination_exists?.must_equal true
      end

      it "returns false if the destination doesn't exist" do
        subject.stubs(destination: '/home/fake.txt')
        subject.destination_exists?.must_equal false
      end
    end

    describe "rename" do
      before do
        @origin_file = File.join("origin.mkv")
        @destination_file = File.join("destination.mkv")
        File.open(@origin_file, 'w'){|f| f.write("ORIGIN")}
        subject.stubs(filename: @origin_file)
        subject.stubs(destination: @destination_file)
      end

      it "raises an exception if the destination already exists and does nothing" do
        File.open(@destination_file, 'w'){|f| f.write("DESTINATION")}
        Proc.new{subject.rename}.must_raise RuntimeError
        File.read(@destination_file).wont_include("ORIGIN")
      end

      it "renames the file if the destination doesn't exist" do
        subject.rename
        File.read(@destination_file).must_include("ORIGIN")
        File.exists?(@origin_file).must_equal false
      end
    end
  end

end
