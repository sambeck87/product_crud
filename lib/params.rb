module Params

  TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON', 'Y'].to_set
  FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE', 'off', 'OFF', 'N'].to_set

  def params_extract_integer!(model, params, key, range: 1..Float::INFINITY, members: nil, required: false, message: nil)
    number = params[key]
    unless number.present?
      model.errors.add(key, message || "is required") if required
      return
    end

    begin
      number = Integer(number)
    rescue ArgumentError
      model.errors.add(key, message || "is invalid")
      return
    end

    if range && !range.cover?(number)
      model.errors.add(key, message || "is out of range")
      return
    end

    if members && !members.include?(number)
      model.errors.add(key, message || "is not included in the list")
      return
    end

    number
  end

  def params_extract_decimal!(model, params, key, range: 0..Float::INFINITY, required: false, message: nil)
    number = params[key]
    unless number.present?
      model.errors.add(key, message || "is required") if required
      return
    end

    begin
      number = Float(number)
    rescue ArgumentError, TypeError
      model.errors.add(key, message || "is invalid")
      return
    end

    if range && !range.cover?(number)
      model.errors.add(key, message || "is out of range")
      return
    end

    number
  end

  def params_extract_string!(model, params, key, range: 0..255, members: nil, regexp: nil, required: false, message: nil)
    string = params[key]
    if string.nil?
      model.errors.add(key, message || "is required") if required
      return
    end

    string = String(string)
    if range && !range.cover?(string.length)
      model.errors.add(key, message || "is too long (maximum is #{range.end} characters)")
      return
    end

    if members && !members.include?(string)
      model.errors.add(key, message || "is not included in the list")
      return
    end

    if regexp && !regexp.match?(string)
      model.errors.add(key, message || "is invalid")
      return
    end

    string
  end

  def params_extract_boolean!(model, params, key, required: false, message: nil)
    value = params[key]

    if value == true || value == false
      return value
    end

    unless value.present?
      model.errors.add(key, message || "is required") if required
      return
    end

    if TRUE_VALUES.include?(value)
      true
    elsif FALSE_VALUES.include?(value)
      false
    else
      model.errors.add(key, message || "is invalid")
    end
  end

  def params_extract_resource!(model, params, key, permit:, required: false, collection_key: nil, collection_permit: nil)
    return params_extract_resources!(model, params, collection_key, permit: [*collection_permit, *permit], required: required) if collection_key && params.key?(collection_key)

    resource = params[key]

    case resource
    when ActionController::Parameters
      unless resource.present?
        model.errors.add(key, "is required") if required
      end
      return permit ? resource.permit(permit) : resource

    when NilClass
      model.errors.add(key, "is required") if required

    else
      model.errors.add(key, "is invalid")
    end
  end
end
