#
# bahasa.js
# Localization for node.js and express
#
# Licensed under the MIT:
# http://www.opensource.org/licenses/mit-license.php
# Copyright (c) 2013, Sebastian E. Ferreyra Pons (sebastian -[at]- gmail [*dot*] com)
# 

#Guru = require("./guru")
Trainee = require("./trainee")
module.exports = (app, options) ->
  "use strict"
  _name = "bahasa"
  config = {}
  
  #
  # The bahasa configuration object.
  #
  config.storage = key: options.storageKey or "language"
  config.cookieOptions = options.cookieOptions or {}
  config.resources =
    #path: options.path
    defaultLocale: options.defaultLocale
    extension: ".json"
    placeholder: /\{(.*?)\}/

  
  #
  # Verify the given parameters.
  #
  # So the middleware init call should look like:
  #
  #     app.configure(function() {
  #         // Lingua configuration
  #         app.use(bahasa(app, {
  #             defaultLocale: 'en',
  #             path: __dirname + '/i18n'
  #         }));
  #     });
  #
  # It is necessary to define the "default locale" and the "path"
  # where bahasa finds the i18n resource files.
  #
  ###
  throw new Error(_name + ": Please define a default locale while registering the middleware.")  unless config.resources.defaultLocale
  unless config.resources.path
    throw new Error(_name + ": Please define a path where " + _name + " can find your locales.")
  else
    config.resources.path = config.resources.path + "/"  if config.resources.path[config.resources.path.length] isnt "/"
  ###
  #
  # Creating the mighty guru object which knows everything.
  #
  #guru = new Guru(config)
  
  #
  # Creating the trainee object which is like a helper for the guru.
  #
  trainee = new Trainee(config)
  
  #
  # summary:
  #     Inits the view helper.
  #
  # description:
  #     To be able to access the defined i18n resource in
  #     the views, we have to register a dynamic helper. With
  #     this it is possible to access the text resources via
  #     the following directive. Be aware that it depends on
  #     the syntax of the used template engine. So for "jqtpl"
  #     it would look like:
  #
  #         ${bahasa.attribute}
  #
  #     # Example #
  #
  #     de-de.json:
  #         {
  #             "title": "Hallo Welt",
  #             "content": {
  #                 "description": "Eine kleine Beschreibung."
  #             }
  #         }
  #
  #     en.json:
  #         {
  #             "title": "Hello World",
  #             "content": {
  #                 "description": "A little description."
  #             }
  #         }
  #
  #     index.html (de-de in the HTTP request header):
  #         <h1>${bahasa.title}</h1> <!-- out: <h1>Hallo Welt</h1> -->
  #         <p>${bahasa.content.description}</h1> <!-- out: <p>Eine kleine Beschreibung.</p> -->
  #
  #
  
  # # Compatibility check
  if typeof app.dynamicHelpers is "function" # Express < 3.0
    app.dynamicHelpers bahasa: (req, res) ->
      res.bahasa.content

  else if typeof app.locals.use is "function" # Express 3.0
    app.locals.use (req, res) ->
      res.locals.bahasa = res.bahasa.content

  #
  # summary:
  #     The middleware function.
  #
  # description:
  #     This function will be called on every single
  #     HTTP request.
  #
  bahasa = (req, res, next) ->
    #
    # Determine the locale in this order:
    # 1. URL query string, 2. Cookie analysis, 3. header analysis
    #
    locales = trainee.determineLocales(req, res)
    
    # Get the resource.
    #resource = guru.ask(locales)
    
    # Save the current language
    #trainee.persistCookie req, res, resource.locale
    
    # Bind the resource on the response object.
    # res.bahasa = resource
    req.locales = locales

    # # Compatibility check
    # Express 3.0 RC
    #res.locals.bahasa = res.bahasa.content  if "function" is typeof app.locals
    next()