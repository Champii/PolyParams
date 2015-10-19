global import require \prelude-ls

module.exports = (...types, f) ->
  types = types |> map ->
    | is-type \String it => type: it
    | is-type \Object it => {type: first keys it} <<< first values it

  # thus = @
  (...args) ->
    resArgs = types
      |> map ->
        argIdx = args |> find-index (arg) -> typeof! arg is it.type

        switch
          | argIdx?                         => delete args[argIdx]
          | not argIdx? and it.optional?    => null
          | not argIdx? and it.default?     => it.default
          | _                               => throw new Error "No arguments of type: #{it.type}"

    f.apply @, resArgs
