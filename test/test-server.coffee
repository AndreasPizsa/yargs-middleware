restify = require 'restify'
server = restify.createServer();
server.listen 3000,()->
  console.log "Listening on #{server.url}"

server.use restify.queryParser()
server.use restify.bodyParser()
server.on 'uncaughtException', (request, response, route, error)->
  console.log JSON.stringify error

server.use (req,res,next)->
  yargs = require 'yargs'

  args = []
  for key,value of req.params
    if key[0]=='-' then args.push key
    else if key.length==1 then args.push "-#{key}"
    else args.push "--#{key}"
    args.push value
  req.yargs = self = yargs args

  require('url').parse req.url

  req.yargs.$0="http://#{req.headers.host}#{req.path()}?"

  req.yargs.terminate = (exitCode)->
    console.log "Terminating #{exitCode}"
    res.send if exitCode == 0 then 200 else 400
    return res.end()

  req.yargs.onFail = (msg) ->
    body = ''
    if self.getShowHelpOnFail() then self.showHelp (help)->
      body+=help

    body += if msg then msg else ''
    #if failMessage
    #  body += "\n"  if msg
    #  body += failMessage

    self.error = new restify.errors.InvalidArgumentError body

  return next()

server.get '/', (req,res,next)->
  args = req.yargs
    .usage('Usage: $0 -x [num] -y [num]')
    .example('$0 -f', 'count the lines in the given file')
    .demand(['x','y'])
    .alias('x', 'xanthippe')
    .describe('x', 'The magical number')
    .argv

  return next req.yargs.error if req.yargs.error

  res.send 200, 'Yo'
  res.end()
  return next()
