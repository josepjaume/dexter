require_relative '../../spec_helper'
require 'dexter/renamer/directory'

require 'mocha'
require 'fakefs'

describe "Parser" do
  before do
    @directory = 'FakeDir'
    FileUtils.mkdir_p('FakeDir/Inside')
    File.open('FakeDir/Dexter S01E02.mkv', 'w'){|f| f.write("X")}
    File.open('FakeDir/Inside/Dexter S02E03.mkv', 'w'){|f| f.write("X")}
  end

  after do
    FakeFS::FileSystem.clear
  end

  subject do
    Dexter::Renamer::Directory.new(@directory)
  end

  describe "file_list" do
    it "lists all the files" do
      subject.file_list.must_include File.expand_path('FakeDir/Dexter S01E02.mkv')
      subject.file_list.must_include File.expand_path('FakeDir/Inside/Dexter S02E03.mkv')
    end

    it "doesn't include dirs" do
      subject.file_list.wont_include File.expand_path('FakeDir')
    end
  end

  describe "files" do
    it "returns all the files from the file list" do
      subject.files.each do |file|
        file.must_be_kind_of Dexter::Renamer::File
      end
    end
  end

  describe "destination_exists?" do
    it "returns false if file destinations doesn't exist" do
      subject.destination_exists?
    end
  end

  describe "rename" do
    it "raises a runtime exception if there's a file with existing destinations" do
      files = subject.files
      subject.files[1].stubs(destination_exists?: true)
      Proc.new{subject.rename}.must_raise RuntimeError
    end
    it "returns true if all files can be moved" do
      subject.rename.must_equal true
    end
  end
end
