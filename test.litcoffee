    # server.use argv

    qargs = require './qargs'
    argv = qargs('email=andreas@butterseite.com&schedule=5 minutes&yo=Andreas&twitter=@AndreasPizsa')
    .usage('Usage: $0 -x [num] -y [num]')
    .demand(['x','y'])

    if true then argv.demand('emailssss')

    argv.argv
    
    console.log argv.x / argv.y
