require "clear_object/version"

module ClearObject
  class Error < StandardError; end

  def clear(*attributes)
    attributes.each do |c_attr|
      @clear_attributes << c_attr
    end
  end

  def clear_attributes
    @clear_attributes ||= []
  end
end
