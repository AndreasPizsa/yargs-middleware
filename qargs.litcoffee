# Middleware
The middleware is the real magic.

    module.exports = ()->
      return (req,res,next)->
        req.qargs = qargs req.search
        req.qargs.terminate = (exitCode)->
          res.end()
          return

    module.exports.yargs = (q)->
      if typeof q isnt 'string' then throw new TypeError 'q must be a String'

      q = q.replace /\b(.)=([^&]*)/gmi,'-$1=$2'
      q = q.replace /\b([^=&]{2,})=([^&]*)/gmi,'--$1=$2'
      args = q.split /&=/

      argv = (require 'yargs')(args)
      return argv
