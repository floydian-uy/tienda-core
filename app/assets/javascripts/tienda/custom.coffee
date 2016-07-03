generateSlug = (url) ->
  url = url.replace(/[^a-zA-Z0-9-_]/g, '-')
  url