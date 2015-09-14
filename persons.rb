module Person
  attr_accessor :name, :preferences
  attr_reader :fiance, :unproposed_list

  def initialize(name = nil, preferences = nil)
    @preferences = preferences
    @name = name
    @fiance = nil
    @unproposed_list = nil
  end

  def single?
    @fiance == nil 
  end

  def engage(partner)
    @fiance = partner
  end

  def unengage
    @fiance = nil
  end

end

class Initiator 
  include Person

  def propose_to_next_preferred
    @unproposed_list = @unproposed_list || @preferences.dup
    highest_ranked_unproposed = @unproposed_list[0]
    highest_ranked_unproposed.proposal_review(self)
    @unproposed_list.shift
  end
  
end

class Receiver
  include Person

  def proposal_review(initiator)
    if self.single?
      new_suitor_acceptance(initiator)
    else
      compare_suitors(initiator)
    end
  end

  def new_suitor_acceptance(initiator)
    self.engage(initiator)
    initiator.engage(self)  
  end

  def compare_suitors(initiator)
    if self.preferences.index(initiator) < self.preferences.index(self.fiance)
      self.fiance.unengage
      new_suitor_acceptance(initiator)
    end
  end

end