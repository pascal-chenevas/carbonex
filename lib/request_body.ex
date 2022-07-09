defmodule Carbonex.RequestBody do
  @enforce_keys ~w(convert_to)a
  @enforce_keys ~w(data)a
  defstruct(
    convert_to: nil,
    data: %{}
  )

  alias __MODULE__

  def to_json(req_body = %RequestBody{}) do
    req_body
    |> Map.from_struct()
    |> Recase.Enumerable.atomize_keys(&Recase.to_camel/1)
    |> Jason.encode()
  end
end
