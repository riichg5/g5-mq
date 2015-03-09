nodemailer = require 'nodemailer'

smtpTransport = nodemailer.createTransport("SMTP",{
    service: "QQ",
    auth: {
        user: "password@funcell123.com",
        pass: "Word@Pass123AOW"
    }
})

class Email
  constructor: (opt) ->
    @mail_service = opt.mail_service      #example 'QQ'
    @mail_user = opt.mail_user            #example 'xxx@qq.com'
    @mail_pwd = opt.mail_pwd
    @mail_to = opt.mail_to                #email addr
    @subject = opt.subject
    @content = opt.content
    @mailOptions =
      from: "<#{@mail_user}>"
      to: "#{@mail_to}"
      subject: @subject
      text: @content
      html: "<p>" + @content + "</p>"
    
  get_transporter: () ->
    self = @
    unless @_transporter
      nodemailer.createTransport "SMTP",
          service: self.mail_service
          auth:
            user: self.mail_user
            pass: self.mail_pwd
    @_transporter

  send: () ->
    @get_transporter().sendMail @mailOptions, (err, response) ->
      if err
        console.log(err)
      else
        console.log("Message sent: " + response.message);

module.exports = Email
