redis = require 'redis'
Email = require './mail'
util = require 'util'

REDIS_COMMON_LIST_KEY = 'mq-common'
REDIS_IMPORTANT_LIST_KEY = 'mq-important'

class MQ
  constructor: (opt) ->
    @identifier = opt.identifier
    @redis_ip = opt.redis_ip
    @redis_port = opt.redis_port
    @remote_addr = opt.remote_addr
    @mail_service = opt.mail_service
    @mail_user = opt.mail_user
    @mail_pwd = opt.mail_pwd
    @mail_to = opt.mail_to

  _get_mail_opt: (subject, content) ->
    mail_service: @mail_service
    mail_user: @mail_user
    mail_pwd: @mail_pwd
    mail_to: @mail_to
    subject: subject
    content: content

  _send_mail: (subject, content, cb) ->
    new Email(@_get_mail_opt(subject, content)).send(cb)

  get_redis_client: () ->
    self = @
    unless @_redis_client
      @_redis_client = redis.createClient @redis_port, @redis_ip
      @_redis_client.on "error", (err) ->
        subject = "【#{self.identifier}】redis error"
        content = util.inspect err
        self._send_mail subject, content, (err) ->
          console.log "send maill error!" if err
    @_redis_client

  add: (item, cb) ->
    client = @get_redis_client()
    if item.important and item.important is true
      client.rpush REDIS_IMPORTANT_LIST_KEY, JSON.stringify(item.data), cb
    else
      client.rpush REDIS_COMMON_LIST_KEY, JSON.stringify(item.data), cb

  #send: () ->


  #monit: () ->


module.exports = MQ