defmodule Elastix.JSON do
  defmodule Codec do
    @callback encode!(data :: any) :: iodata

    @callback decode(json :: iodata, opts :: []) :: {:ok, any} | {:error, :invalid}
  end

  @moduledoc """
  A wrapper for JSON libraries with Poison as the default implementation.

  To override, implement the Elastix.JSON.Codec behavior and specify it in application config like:

  ```
  config :elastix,
    json_codec: JiffyCodec
  ```

  Decode options can be specified in application config like:

  ```
  # Poison decode with atom keys
  config :elastix,
    json_options: [keys: atoms!]
  ```

  ```
  # Jiffy decode with maps
  config :elastix,
    json_codec: JiffyCodec,
    json_options: [:return_maps]
  ```
  """

  @doc false
  def encode!(data) do
    codec().encode!(data)
  end

  @doc false
  def decode(json) do
    codec().decode(json, json_options())
  end

  @doc false
  defp json_options() do
    # support poison_options config
    case Elastix.config(:poison_options) do
      nil -> Elastix.config(:json_options, [])
      opts -> opts
    end
  end

  defp codec() do
    Elastix.config(:json_codec, Poison)
  end
end
