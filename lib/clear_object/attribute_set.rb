module ClearObject
  class AttributeSet < Set
    def <<(attribute)
      if none? { |member| member.name == attribute.name}
        add(attribute)
      end
    end
  end
end
