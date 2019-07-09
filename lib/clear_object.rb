# frozen_string_literal: false

require 'clear_object/version'
require 'clear_object/attribute'

module ClearObject
  class Error < StandardError; end

  def clear(*attributes, default: nil, &block)
    attributes.each do |c_attr|
      @clear_attributes << Attribute.new(name: c_attr, default: default)
    end

    class_eval %Q{
        attr_reader *#{clear_attributes.map { |c_attr| c_attr.name }}
        #{custom_initialize_def}
    }
  end

  def clear_object!
    @clear_attributes = []
  end
  
  #private
  def clear_attributes
    @clear_attributes ||= Set.new
  end

  def custom_initialize_def
    initialize_def = clear_attributes.map do |c_attr|
      if c_attr.default
        "#{c_attr.name}: #{get_default(c_attr.default)}"
      else
        "#{c_attr.name}:"
      end
    end.join(', ')

    initialize_body = ''.tap do |init_body|
      clear_attributes.each do |c_attr|
        init_body << "@#{c_attr.name} = #{c_attr.name}"
      end
    end

    %Q{
      def initialize(#{initialize_def})
        #{initialize_body}
      end
    }
  end

  #TODO: Try to get rid of this
  def get_default(value)
    if value.class == String
      "'#{value}'"
    else
      value
    end
  end
end
