class NotificationMailer < ActionMailer::Base
  default from: "no-reply@nomnomtacos.com"

  def comment_added
  	mail(to: "ajose01@gmail.com",
  		subject: "A comment has been added to your place")
  end
end
