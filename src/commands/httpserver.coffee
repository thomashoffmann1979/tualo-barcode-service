{Command} = require 'tualo-commander'
path = require 'path'
fs = require 'fs'
os = require 'os'
glob = require 'glob'
mkdirp = require 'mkdirp'
{spawn} = require 'child_process'

QRCode = require 'qrcode'


PDFDocument = require('pdfkit')
app = require('express')()
http = require('http').Server(app)
bbs = require('../main')
parseString = require('xml2js').parseString;

grayprinter=''
colorprinter=''




module.exports =
class HttpServer extends Command
  @commandName: 'httpserver'
  @commandArgs: ['port']
  @commandShortDescription: 'running the service'
  @options: []

  @help: () ->
    """

    """

  action: (options,args) ->
    me = @
    if args.port
      @args = args
      @prnNumber = 10000
      @tempdir = path.join(os.tmpdir(),'cs')
      #'/Users/thomashoffmann/Desktop/hybrid-test'

      mkdirp @tempdir,(err) ->
        if err
          console.error err
      @openExpressServer()

  openExpressServer: () ->
    express = require('express')
    bodyParser = require('body-parser')
    app = express()

    app.use bodyParser.json()
    app.use bodyParser.urlencoded {extended: true}
    
    #app.use '/hls/app', express.static( path.join('.','www','app') )
    #app.use '/app', express.static( path.join('.','www','app') )
    #app.use '/hls/preview', express.static( @tempdir )

    app.get '/', (req, res) =>
      result = {success: true}
      res.send(JSON.stringify(result))

    app.get '/qr/:id', (req, res) =>
      opt = {errorCorrectionLevel: 'Q'}
      console.log req.params.id
      fname = path.join(os.tmpdir(),'cs','code.png')
      QRCode.toFile  fname, req.params.id, opt, (err) ->
        res.sendFile fname





    app.listen @args.port,'0.0.0.0'


