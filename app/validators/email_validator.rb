# frozen_string_literal: true

require 'mail'
class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    result = check!(value)
    record.errors[attribute] << options[:message] || 'is invalid' unless result

    return unless User::TEMPORARY_EMAIL_REGEXP.match?(value)
    record.errors[attribute] << 'must be given. Please, give u a real one.'
  end

  private

  def check!(value)
    mail = Mail::Address.new(value)
    !mail.domain.nil? && mail.domain.match?('\.') && mail.address == value
  rescue StandardError
    false
  end
end
