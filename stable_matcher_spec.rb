require "./stable_matcher"

describe "StableMatcher" do
  before :each do
    @johnny   = Person.new("Johnny Depp")
    @mads     = Person.new("Mads Mikkelsen")
    @ryan     = Person.new("Ryan Gosling")

    @rachel   = Person.new("Rachel McAdams",  [@mads, @johnny, @ryan])
    @penelope = Person.new("Penelope Cruz",   [@johnny, @mads, @ryan])
    @natalie  = Person.new("Natalie Portman", [@mads, @johnny, @ryan])
 
    @johnny.preferences = [@rachel, @penelope, @natalie]
    @mads.preferences   = [@rachel, @penelope, @natalie]
    @ryan.preferences   = [@penelope, @natalie, @rachel]

    initiators = [@johnny, @mads, @ryan]
    receivers  = [@rachel, @penelope, @natalie]

    @simulation = StableMatcher.new(SpecificPersonsGenerator.new(initiators, receivers))
  end

  describe "#dating_game" do
    it "simulation continues until all initiators are not single" do
      expect{@simulation.dating_game}.to change{@simulation.initiators.any? { |initiator| initiator.single? }}.from(true).to(false)
    end
  end

  describe "#propose_to_next_preferred" do
    context "before rounds have started" do
      it "unproposed list starts as empty"do
        expect{@johnny.propose_to_next_preferred}.to change{@johnny.unproposed_list}.from(nil).to([@penelope, @natalie])
      end
    end

    context "after rounds have started" do
      before do
        @johnny.propose_to_next_preferred
      end
      it "already proposed to receivers are removed from unproposed list" do
        expect{@johnny.propose_to_next_preferred}.to change{@johnny.unproposed_list}.from([@penelope, @natalie]).to([@natalie])
      end
    end
  end

  describe "#engage" do
    it "receiver's fiance becomes initiator" do
      expect {@johnny.engage(@natalie)}.to change{@johnny.fiance}.from(nil).to(@natalie)
    end

    it "initiator's fiance becomes receiver" do
      expect {@johnny.engage(@natalie)}.to change{@natalie.fiance}.from(nil).to(@johnny)
    end
  end

  describe "#unengage" do
    before :each do
      @johnny.engage(@natalie)
    end
    it "person's fiance becomes nil" do
      expect {@johnny.unengage}.to change{@johnny.fiance}.from(@natalie).to(nil)
    end

    it "the fiance of the person's old fiance becomes nil" do
      expect {@johnny.unengage}.to change{@natalie.fiance}.from(@johnny).to(nil)
    end
  end

  describe "#clear_marital_statuses" do
    before do
      @simulation.dating_game
    end

    it "changes all receivers' fiances to nil" do
      expect {@simulation.clear_marital_statuses}.to change{@simulation.receivers.all? {|receiver| receiver.fiance != nil }}.from(true).to(false)
    end

    it "changes all initiators' fiances to nil" do
      expect {@simulation.clear_marital_statuses}.to change{@simulation.initiators.all? {|initiator| initiator.fiance != nil }}.from(true).to(false)
    end
  end

  describe "#play_round" do 
    context "when receiver has more than one offer" do
      it "receiver accepts preferred offer even if it's not first" do
        expect{@simulation.play_round}.to change{@rachel.fiance}.from(nil).to(@mads)
      end
    end

    context "when receiver accepts proposal" do
      it "receiver is no longer single" do
        expect{@simulation.play_round}.to change{@rachel.single?}.from(true).to(false)
      end
      it "initiator is no longer single" do
        expect{@simulation.play_round}.to change{@mads.single?}.from(true).to(false)
      end
    end

    context "when receiver of proposal is already engaged and prefers new suitor" do
      before :each do
        @simulation.play_round
      end
      it "receiver becomes engaged to new suitor" do
        expect{@simulation.play_round}.to change{@penelope.fiance}.from(@ryan).to(@johnny)
      end

      it "new suitor becomes engaged to receiver" do
        expect{@simulation.play_round}.to change{@johnny.fiance}.from(nil).to(@penelope)
      end

      it "old fiance becomes unengaged" do
        expect{@simulation.play_round}.to change{@ryan.fiance}.from(@penelope).to(nil)
      end
    end

    context "when receiver of proposal is already engaged and does not prefer new suitor" do
      before :each do
        @penelope.preferences = [@ryan, @johnny, @mads]
        @simulation.play_round
      end
      it "receiver remains engaged to existing fiance" do
        expect{@simulation.play_round}.not_to change{@penelope.fiance}
      end

      it "new suitor remains single" do
        expect{@simulation.play_round}.not_to change{@ryan.fiance}
      end

      it "existing fiance remains engaged to receiver" do
        expect{@simulation.play_round}.not_to change{@johnny.fiance}
      end
    end 
  end

  describe "#reverse_roles" do
    it "switches the initiator group to become the original receivers" do
      expect{@simulation.reverse_roles}.to change{@simulation.initiators}.from([@johnny, @mads, @ryan]).to([@rachel, @penelope, @natalie])
    end

    it "switches the receiver group to become the original initiators" do
      expect{@simulation.reverse_roles}.to change{@simulation.receivers}.from([@rachel, @penelope, @natalie]).to([@johnny, @mads, @ryan])
    end
  end
end