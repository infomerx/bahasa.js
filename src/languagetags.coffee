#
# * express-lingua
# * An i18n middleware for the Express.js framework.
# *
# * Licensed under the MIT:
# * http://www.opensource.org/licenses/mit-license.php
# *
# * Copyright (c) 2013, André König (andre.koenig -[at]- gmail [*dot*] com)
# *
# 

#
#
# summary:
#     A class associating language tags with quality values
#
# description:
#     A language tag identifies a language as described at
#     <http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.10>
#     (e.g. 'en-us'). A quality value (qvalue) determines the
#     relative degree of preference for a language tag . Tags and
#     qvalues are present in the HTTP Accept-Language header
#     (http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4)
#     (e.g. 'Accept-Language: en-gb,en-us;q=0.7,en;q=0.3')
#
generator = ->
  "use strict"
  LanguageTags = ->
    @tagQvalues = {} # associates 'q' values with language tags
    return

  
  #
  #
  # summary:
  #     Associate a tag with a qvalue
  #
  # description:
  #     More than one tag can be assigned to the same qvalue.
  #
  LanguageTags::addTag = (tag, qvalue) ->
    try
      @tagQvalues[qvalue].push tag
    catch e
      throw e  unless e instanceof TypeError
      @tagQvalues[qvalue] = [tag]
    return

  
  #
  #
  # summary:
  #     Associate multiple tags with a qvalue
  #
  # description:
  #     A convenience method to save calling LanguageTags.addTag() multiple
  #     times.
  #
  LanguageTags::addTags = (tags, qvalue) ->
    try
      @tagQvalues[qvalue].push.apply @tagQvalues[qvalue], tags
    catch e
      throw e  unless e instanceof TypeError
      @tagQvalues[qvalue] = tags
    return

  
  #
  #
  # summary:
  #     Get a list of all tags
  #
  # description:
  #     The list of tags is ordered by the associated tag qvalue in
  #     descending order.
  #
  LanguageTags::getTags = ->
    
    # get the reverse ordered list of qvalues e.g. -> [1, 0.8, 0.5, 0.3]
    qvalues = []
    qvalue = undefined
    tags = []
    that = this
    for qvalue of @tagQvalues
      qvalues.push qvalue  if @tagQvalues.hasOwnProperty(qvalue)
    qvalues = qvalues.sort().reverse()
    
    # add the tags to the tag list, ordered by qvalue
    qvalues.forEach (qvalue) ->
      tags.push.apply tags, that.tagQvalues[qvalue]
      return

    tags

  LanguageTags

module.exports = generator()