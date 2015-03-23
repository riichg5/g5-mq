class logger
  @show: () ->
    arg_length = arguments.length
    return if arg_length is 0
    args = []
    args.push "---->"
    for i,v in arguments
      args.push v
    console.log.apply console, args

  @log: () ->


module.exports = logger
