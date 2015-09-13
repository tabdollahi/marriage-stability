require 'namey'
$generator = Namey::Generator.new

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