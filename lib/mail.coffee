nodemailer = require 'nodemailer'


class Email
  constructor: (opt) ->
    @mail_service = opt.mail_service      #example 'QQ'
    @mail_user = opt.mail_user            #example 'xxx@qq.com'
    @mail_pwd = opt.mail_pwd
    @mail_to = opt.mail_to                #email addr
    @subject = opt.subject
    @content = opt.content
    @mailOptions =
      from: "#{@mail_user}"
      to: "#{@mail_to}"
      subject: @subject
      text: @content
      html: "<p>" + @content + "</p>"
    
  get_transporter: () ->
    self = @
    unless @_transporter
      @_transporter = nodemailer.createTransport 
        service: self.mail_service
        auth:
          user: self.mail_user
          pass: self.mail_pwd
    @_transporter

  send: (cb) ->
    @get_transporter().sendMail @mailOptions, (err, response) ->
      if err
        cb(err)
      else
        cb(null)

module.exports = Email
