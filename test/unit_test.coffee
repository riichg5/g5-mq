MQ = require '../index'

opt = 
  identifier: "test-server"
  redis_ip: "127.0.0.1"
  redis_port: 6379
  remote_addr: "http://127.0.0.1:80"
  mail_service: "QQ"
  mail_user: "password@funcell123.com"
  mail_pwd: "Word@Pass123AOW"
  mail_to: "tolibo@qq.com"  

describe "MQ", () ->
  this.timeout(0)
  beforeEach (done) ->
    done null

  describe "mq.add", () ->
    it "mq.add", (done) ->
      mq = new MQ(opt)
      mq.add {data:{name: "libo-im"}, important: true}, (err) ->
        done err

  describe "mq.add", () ->
    it "mq.add", (done) ->
      mq = new MQ(opt)
      mq.add {data:{name: "libo-com"}, important: false}, (err) ->
        done err