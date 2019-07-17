# frozen_string_literal: false
require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.setup

module ClearObject
  class Error < StandardError; end

  def clear(*attributes, default: nil, **opts, &block)
    attributes.each do |c_attr|
      attr_reader c_attr

      if block_given?
        klass = Class.new do
          extend ClearObject
          class_eval(&block)
        end
        # How come this is working?
        Object.const_set((opts[:clear_name] || c_attr).to_s.capitalize, klass)
      end
      clear_attributes << Attribute.new(name: c_attr, default: default)
    end

    class_eval(custom_initialize_def)
  end

  def clear_object!
    @clear_attributes = AttributeSet.new
  end

  def clear_get_default_for(name)
    value = clear_attributes.detect { |c_attr| c_attr.name == name }.default
    if value.respond_to?(:call)
      value.call
    else
      value
    end
  end

  #private
  def clear_attributes
    @clear_attributes ||= AttributeSet.new
  end

  def custom_initialize_def
    initialize_def = clear_attributes.map do |c_attr|
      if c_attr.default
        "#{c_attr.name}: self.class.clear_get_default_for(:#{c_attr.name})"
      else
        "#{c_attr.name}:"
      end
    end.join(', ')

    initialize_body = ''.tap do |init_body|
      clear_attributes.each do |c_attr|
        init_body << "@#{c_attr.name} = #{c_attr.name}\n"
      end
    end

    %Q{
      def initialize(#{initialize_def})
        #{initialize_body}
      end
    }
    end
  end
