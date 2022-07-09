defmodule Carbonex.ConvertTo do
  @enforce_keys ~w(format_name)a
  @enforce_keys ~w(format_options)a

  defstruct format_name: "csv", format_options: nil
end
