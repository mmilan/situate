class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("GMAIL_USERNAME", "noreply@situate.us")
  layout "mailer"
end
