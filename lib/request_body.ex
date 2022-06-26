defmodule Carbonex.RequestBody do
  @enforce_keys ~w(convert_to)a
  @enforce_keys ~w(data)a
  defstruct(
    convert_to: nil,
    data: %{}
  )

  def to_json(req_body = %Carbonex.RequestBody{}) do
    req_body
    |> camelize_keys
    |> Jason.encode()
  end

  def camelize_keys(req_body = %{convert_to: convert_format, data: _})
      when is_binary(convert_format) do
    req_body
    |> Map.from_struct()
    |> Enum.into(%{}, fn {k, v} -> {camelize_key(k), v} end)
  end

  # private functions

  defp camelize_key(key) when is_atom(key) do
    value = Macro.camelize(Atom.to_string(key))
    first_letter = first_letter_to_lowercase(value)
    last_part = last_part(value)
    first_letter <> last_part
  end

  defp first_letter_to_lowercase(value) do
    value
    |> String.first()
    |> String.downcase()
  end

  defp last_part(value) do
    string_length = String.length(value)

    if string_length > 0 do
      value
      |> String.slice(1, string_length)
    else
      value
    end
  end
end
