# frozen_string_literal: false

require 'clear_object/version'

module ClearObject
  class Error < StandardError; end

  def clear(*attributes, **)
    attributes.each do |c_attr|
      @clear_attributes << c_attr
    end

    class_eval %Q{
        attr_reader *#{clear_attributes}
        def initialize(#{initialize_definition})
          #{initialize_body}
        end
    }
  end

  def clear_attributes
    @clear_attributes ||= Set.new
  end

  def initialize_definition
    ''.tap do |defi|
      clear_attributes.each_with_index do |c_attr, index|
        defi << "#{c_attr}:"
        defi << ', ' unless clear_attributes.size - 1 == index
      end
    end
  end

  def initialize_body
    ''.tap do |init_body|
      clear_attributes.each do |c_attr|
        init_body << "@#{c_attr} = #{c_attr}"
      end
    end
  end

  def clear_object!
    @clear_attributes = []
  end
end
