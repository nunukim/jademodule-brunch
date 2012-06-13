jade = require 'jade'
sysPath = require 'path'

modulize = (->
  isFunc = (obj)-> obj and obj.call? and obj.apply?
  getBuf = null
  mdl = {exports: {}}
  ((module, exports)->
    __JADE_FUNCTION_HERE__()
  )(mdl, mdl.exports)
  throw new Error("something wrong!!!") unless isFunc(getBuf)
  getBuf().length = 0
  wrap = (func)-> ->
    bufIdx = getBuf().length
    func.apply(this, arguments)
    getBuf().splice(bufIdx).join('')
  for key, val of mdl.exports
    module.exports[key] = if isFunc(val) then wrap(val) else val
).toString()

module.exports = class JadeModuleCompiler
  brunchPlugin: yes
  type: 'template'
  extension: 'jdlb'

  constructor: (@config) -> null

  compile: (data, path, callback) ->
    try
      data = "- getBuf = function(){return buf;};\n" + data
      jadeFunc = jade.compile data,
        compileDebug: no
        client: yes
        filename: path
        pretty: !!@config.plugins?.jade?.pretty
      result = "(" + modulize.replace("__JADE_FUNCTION_HERE__", "(#{jadeFunc})") + ")();"
    catch err
      error = err
    finally
      callback error, result

  # Add '../node_modules/jade/jade.js' to vendor files.
  include: [
    (sysPath.join __dirname, '..', 'node_modules', 'jade', 'runtime.js')
  ]
