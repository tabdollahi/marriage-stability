require "./marriage_stability"
describe "#play_round" do 
  before :each do
    preference_hash = {
        initiators: {
          0=> [0,1,2],
          1=> [1,0,2],
          2=> [2,1,0]
          },
        receivers: {
          0=> [0,1,2],
          1=> [0,1,2],
          2=> [1,0,2]
          }
      }
      @stable_matcher = StableMatching.new(3, preference_hash)
  end
  context "when receiver of proposal is single" do
    it "receiver accepts proposal and becomes engaged" do
      expect{@stable_matcher.play_round}.to change{@stable_matcher.receivers[0].single}.from(true).to(false)
    end
    it "initiator becomes engaged" do
      expect{@stable_matcher.play_round}.to change{@stable_matcher.initiators[0].single}.from(true).to(false)
    end
  end
end