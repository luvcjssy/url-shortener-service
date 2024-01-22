module Api
  module ErrorFormatter
    def error_format(code, messages)
      msg = if messages.is_a?(String)
              messages
            elsif messages.is_a?(Array)
              messages.join(' - ')
            end

      { success: false, error: { code: code, message: msg } }
    end
  end
end
