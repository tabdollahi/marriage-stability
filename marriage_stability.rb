require 'namey'
$generator = Namey::Generator.new

module Person
  attr_accessor :name, :preferences
  attr_reader :fiance

  def initialize(name = nil, preferences = nil)
    @preferences = preferences
    @name = name
    @fiance = nil
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
    highest_ranked_unproposed = self.preferences[0]
    highest_ranked_unproposed.proposal_review(self)
    self.preferences.shift
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

class StableMatching

  attr_reader :initiators, :receivers

  def initialize(generator)
    @initiators = generator.initiators
    @receivers = generator.receivers
  end

  def dating_game
    while @initiators.any? { |initiator| initiator.single? }
      play_round
    end
  end

  def play_round
    @initiators.select {|x| x.single?}.each do |current_suitor|
      current_suitor.propose_to_next_preferred
    end
  end

  def display_preferences
    display_helper(@initiators)
    display_helper(@receivers)
  end

  def display_engagements
    puts "*"*80
    puts "Engagements"
    @receivers.each do |receiver|
      if receiver.fiance != nil
        puts "#{receiver.name}: #{receiver.fiance.name}"
      end
    end
  end

  private

  def display_helper(group)
    group.each do |person|
      puts "These are #{person.name}'s preferences:"
      person.preferences.each {|person| puts person.name}
      puts "*"*80
    end
  end

end

class RandomPersonsGenerator

  attr_reader :initiators, :receivers

  def initialize(participant_count)
    @initiators = Array.new(participant_count) {Initiator.new}
    @receivers = Array.new(participant_count) {Receiver.new}
    set_names_male(@initiators)
    set_names_female(@receivers)
    set_preferences
  end

  private

  def set_preferences
    set_preferences_helper(@initiators, @receivers)
    set_preferences_helper(@receivers, @initiators)
  end

  def set_preferences_helper(group_one, group_two)
    group_one.each do |person|
      person.preferences = group_two.shuffle
    end
  end

  def set_names_male(group)
    group.each do |person|
      person.name = $generator.male
    end
  end

  def set_names_female(group)
    group.each do |person|
      person.name = $generator.female
    end
  end

end

class SpecificPersonsGenerator

  attr_reader :initiators, :receivers

  def initialize(initiators, receivers)
    @initiators = initiators
    @receivers = receivers
  end

end



# test = StableMatching.new(RandomPersonsGenerator.new(4))


# test.display_preferences
# test.dating_game
# test.display_engagements
