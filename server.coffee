express  = require 'express'
fs = require 'fs'
app = express()

directoryImages = "#{__dirname}/tmp"


app.use express.logger('dev')
app.use(express.bodyParser({ keepExtensions: true, uploadDir: directoryImages}))


app.get '/', (req, res) ->
  res.send 'Ping!'


app.post '/', (req, res) ->
  unless req?.files?.image
    return res.json
      success: false
      message: 'Image is required'

  img = req.files.image
  filename = img.originalFilename
  path = img.path

  if fs.existsSync("#{directoryImages}/#{filename}")
    fs.unlinkSync(path)
    return res.json
      success: true
      message: "Image exists"

  fs.rename path, "#{directoryImages}/#{filename}", (err) ->
    if err
      return res.json
        success: false
        message: err

    res.json
      success: true
      message: 'Ok'


app.listen 4002
console.log "app running in port 4002"