defmodule Carbonex.HttpHeaders do
  @enforce_keys ~w(version)a
  @enforce_keys ~w(authorization)a

  defstruct authorization: nil, content_type: "application/json", version: nil

  def to_list(value = %Carbonex.HttpHeaders{}) do
    authorization = {"Authorization", "Bearer #{value.authorization}"}
    content_type = {"Content-type", value.content_type}
    carbone_version = {"carbone-version", value.version}

    [authorization, content_type, carbone_version]
  end

  def from_environment(env = %Carbonex.Environment{}) do
    %Carbonex.HttpHeaders{authorization: env.token, version: env.version}
    |> to_list
  end

  def from_environment(env = %Carbonex.Environment{}, content_type) do
    %Carbonex.HttpHeaders{
      authorization: env.token,
      version: env.version,
      content_type: content_type
    }
    |> to_list
  end

  def from_environment_for_multipart(env = %Carbonex.Environment{}, multipart) do
    content_length = Multipart.content_length(multipart)
    content_type = Multipart.content_type(multipart, "multipart/form-data")

    %Carbonex.HttpHeaders{
      authorization: env.token,
      version: env.version,
      content_type: content_type
    }
    |> to_list
    |> Enum.concat([{"Content-Length", to_string(content_length)}])
  end
end
