class Notifier < ActionMailer::Base
  default :from => "Dietrich"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.send_email.subject
  #
  def send_email(attachment_name, destinataire)
    @greeting = "Hi"
		attachments["#{attachment_name}.csv"] = File.read("#{RAILS_ROOT}/public/attachments/#{attachment_name}.csv")
    mail :to => destinataire
  end
end
