This is an experimental attempt at improving how we work with URL arguments.

The idea is that calling a URL actually is very similar to command line apps:
+ you call an executable on certain a path
+ you pass it parameters
+ you read from "stdin" (`req.body`)
+ you write to "stdout" (`res.body`)

(Yuck, this sounds confusingly like PHP :innocent:)

In an ideal world, you should be able to do something like the following:

```javascript
express = require('request');
app  = express();

app.use(require('yargs-middleware'));

app.get('/line_count',function(req,res,next){
  var argv = req.yargs
      .usage('Count the lines in a file.\nUsage: $0')
      .example('$0 -f', 'count the lines in the given file')
      .demand('f')
      .alias('f', 'file')
      .describe('f', 'Load a file')
      .argv
  ;
});
```

And then if you did

```bash
$ curl http://localhost/line_count
```

you'd get something like (draft)

```javascript
HTTP/1.1 400 Missing required arguments: f
Content-Type: application/json; yargs=1.0

{
  error: {
    message: 'Missing required arguments: f',
  },
  yargs: {
    usage: 'Count the lines in a file.\nUsage: curl http://localhost/line_count?f=1',
    examples: [
      'curl http://localhost/line_count?f=myfile.txt   count the lines in the given file'
    ],
    options: {
      'f' : {
        alias: 'file',
        description: 'Load a file',
        is_required: true
      }
    }
  }
}
```

Most of the functionality is already provided by `yargs` and would just have to be adapted to fit the requirements of HTTP.

### Future Direction
Since we're returning structured information about the command, this will take a an interesting direction when taken from there:

+ binding local 'scripts' to remote 'commands'.
  `$ line_count -f myfile.txt` will actually do `http://myhost.com/line_count&f=myfile.txt` (Has this been done yet? Some geek must have done this already!)
+ generating API stubs and proxy classes.
+ generating formatted documentation (eg HTML documentation as another middleware module)

{%= getAuthors() %}
