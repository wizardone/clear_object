# frozen_string_literal: false

require 'clear_object/version'

module ClearObject
  class Error < StandardError; end

  def clear(*attributes, **)
    attributes.each do |c_attr|
      @clear_attributes << c_attr unless @clear_attributes.include?(c_attr)
    end

    custom_initialize
  end

  def clear_attributes
    @clear_attributes ||= []
  end

  def initialize_definition
    ''.tap do |defi|
      clear_attributes.each_with_index do |c_attr, index|
        defi << "#{c_attr}: "
        defi << ', ' unless clear_attributes.size - 1 == index
      end
    end
  end

  def custom_initialize
    class_eval do
      def initialize(initialize_definition)
        puts "Initializing stuff"
      end
    end
  end

  def clear_object!
    @clear_attributes = []
  end
end
