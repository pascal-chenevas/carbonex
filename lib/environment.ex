defmodule Carbonex.Environment do
  @enforce_keys ~w(token)a
  defstruct token: nil, version: "3", base_uri: "https://render.carbone.io"
end
