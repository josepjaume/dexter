require_relative '../../spec_helper'
require 'dexter/detective/episode'

describe Dexter::Detective::Episode do
  subject do
    Dexter::Detective::Episode.new(data)
  end

  let(:data) do
    {
      name: 'Dexter',
      season: 2,
      episode: 1
    }
  end

  describe "given an arbitrary method" do
    describe "if there's a value for the hash for that method name" do
      it "returns the value of the hash key" do
        subject.name.must_equal 'Dexter'
      end
    end
    describe "if there isn't a value for the hash for that method name" do
      it "returns nil" do
        subject.fake.must_equal nil
      end
    end
  end

  describe "#padded_episode" do
    it "returns the episode number with a leading 0" do
      subject.padded_episode.must_equal "01"
    end
  end

  describe "#padded_season" do
    it "returns the season number with a leading 0" do
      subject.padded_season.must_equal "02"
    end
  end
end