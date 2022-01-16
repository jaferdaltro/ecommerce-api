class FutureDateValidator < ActiveModel::EachValidator
  def validate_each(record, attrubute, value)
    if value.present? && value <= Time.zone.now
      message = options[:message] || :future_date
      record.errors.add(attrubute, message)
    end
  end
end