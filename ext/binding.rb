class Binding

  def locals
    @locals ||= {}
  end

  def []=(key, value)
    locals[key] = value
  end

  def method_missing(method)
    locals[method]
  end

end
