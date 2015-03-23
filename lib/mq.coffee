redis = require 'redis'
Email = require './mail'
util = require 'util'
Logger = require './logger'
async = require 'async'

REDIS_COMMON_LIST_KEY = 'mq-common'
REDIS_IMPORTANT_LIST_KEY = 'mq-important'

PER_MSG_AMOUNT = 10
SEND_CHECK_INTERVAL = 100   #per 0.1 second, check the task
SENDIND_QUEUE = []

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

  _sleep: (seconds, func) ->
    @_sleep_handle = setTimeout () ->
        clearTimeout(@_sleep_handle)
        func()
      , seconds * 1000
 
  _http_post: (msg) ->


  _get_msg_item: (queue_name, msg) ->
    {data: msg, important: if REDIS_IMPORTANT_LIST_KEY is queue_name then true else false}

  _send_msg: (queue_name) ->
    self = @
    async.each [0..PER_MSG_AMOUNT], (num, ecb) ->
      @get_redis_client().lpop queue_name, (err, msg) ->
        return ecb(null) if err or !msg
        @_http_post msg, (err) ->
          if err
            self.add self._get_msg_item(queue_name, msg), (err) ->
              Logger.log msg        #写日志文件
              ecb(err)
          else
            ecb(null)

  _send: () ->
    if SENDIND_QUEUE.length is 0
      async.parallel [
          (err, pcb) ->
            @get_redis_client().llen(REDIS_IMPORTANT_LIST_KEY, (err, len) -> 
              pcb err, len
          (err, pcb) ->
            @get_redis_client().llen(REDIS_COMMON_LIST_KEY, (err, len) -> 
              pcb err, len
        ]
        , (err, llens) ->
          if err
            Logger.show "redis llen error:", err
            return
          important_amount = llens[0]
          common_amount = llens[1]
          if important isnt 0

          


      get_redis_client().lpop REDIS_COMMON_LIST_KEY, (err, item) ->

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

  start: () ->
    Logger.show "start send msg"
    @_send_handle = setInterval @_send, SEND_CHECK_INTERVAL

  #monit: () ->


module.exports = MQ