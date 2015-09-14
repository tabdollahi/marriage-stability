require 'namey'
$generator = Namey::Generator.new

class RandomPersonsGenerator

  attr_reader :initiators, :receivers

  def initialize(options)
    @initiators = Array.new(options[:participant_count]) {Person.new}
    @receivers = Array.new(options[:participant_count]) {Person.new}
    set_names(@initiators, options[:initiator_gender])
    set_names(@receivers, options[:receiver_gender])
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

  def set_names(group, gender)
    group.each do |person|
      person.name = $generator.send(gender.to_sym)
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