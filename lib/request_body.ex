defmodule Carbonex.RequestBody do
  @enforce_keys ~w(convert_to)a
  @enforce_keys ~w(data)a
  defstruct(
    convert_to: nil,
    data: %{}
  )

  def to_json(req_body = %Carbonex.RequestBody{}) do
    req_body
    |> Map.from_struct()
    |> prepare_request_body
    |> Jason.encode()
  end

  ##### private functions

  defp prepare_request_body(req_body) do
    Enum.into(req_body, %{}, fn {k, v} -> {camelize(k), v} end)
  end

  defp camelize(key) when is_atom(key) do
    key
    |> Atom.to_string()
    |> Macro.camelize()
    |> first_letter_to_lowercase
  end

  defp get_first_letter_to_lowercase(value) do
    value
    |> String.first()
    |> String.downcase()
  end

  defp get_last_part_string(value) do
    string_length = String.length(value)

    value
    |> String.slice(1, string_length)
  end

  defp first_letter_to_lowercase(value) do
    first_letter = get_first_letter_to_lowercase(value)
    last_part = get_last_part_string(value)
    first_letter <> last_part
  end
end
