require "./marriage_stability"

describe "MarriageStabilityStats" do
  before :each do
    @johnny   = Initiator.new("Johnny Depp")
    @mads     = Initiator.new("Mads Mikkelsen")
    @ryan     = Initiator.new("Ryan Gosling")

    @rachel   = Receiver.new("Rachel McAdams",  [@mads, @johnny, @ryan])
    @penelope = Receiver.new("Penelope Cruz",   [@johnny, @mads, @ryan])
    @natalie  = Receiver.new("Natalie Portman", [@mads, @johnny, @ryan])
 
    @johnny.preferences = [@rachel, @penelope, @natalie]
    @mads.preferences   = [@rachel, @penelope, @natalie]
    @ryan.preferences   = [@penelope, @natalie, @rachel]

    initiators = [@johnny, @mads, @ryan]
    receivers  = [@rachel, @penelope, @natalie]

    @simulation = StableMatching.new(SpecificPersonsGenerator.new(initiators, receivers))
    @stats_finder = MarriageStabilityStats.new
  end

  describe "#average_group_partner_rank" do
    before :each do
      @simulation.dating_game
      @simulation.display_marital_statuses
    end
    it "finds the average rank of the receivers' respective final partners" do
      expect(@stats_finder.average_group_partner_rank(@simulation, :receivers)).to be ==(1.6666666666666667)
    end
    it "finds the average rank of the initiators' respective final partners" do
      expect(@stats_finder.average_group_partner_rank(@simulation, :initiators)).to be ==(1.6666666666666667)
    end
  end
end