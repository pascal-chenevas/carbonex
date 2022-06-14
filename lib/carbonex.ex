defmodule Carbonex do
  @moduledoc """
  Documentation for `Carbonex`.

  `Carbonex` is a small library that help to create a document rendered by https://carbone.io
  """

  @doc """
  create/3 create a document based on a givem template
  and its data
  """
  def create(finch_name, template_file_name, request_body) do
    add_template(finch_name, template_file_name)
    |> render_template(finch_name, request_body)
    |> get_document(finch_name)
  end

  @doc """
  add_template/2 add a carbone template to the Carbone service
  """
  def add_template(finch_name, template_file_name) do
    if File.exists?(template_file_name) do
      base_uri = get_carbone_serice_base_uri()
      api_token = get_api_token()
      multipart = create_multipart(template_file_name)
      body_stream = Multipart.body_stream(multipart)
      content_length = Multipart.content_length(multipart)
      content_type = Multipart.content_type(multipart, "multipart/form-data")

      headers = [
        {"Content-Type", content_type},
        {"Content-Length", to_string(content_length)},
        {"Authorization", "Bearer #{api_token}"},
        {"carbone-version", "3"}
      ]

      Finch.build(:post, "#{base_uri}/template", headers, {:stream, body_stream})
      |> Finch.request(finch_name)
      |> case do
        {:ok, response} ->
          get_id_from_response(response)

        _ ->
          nil
      end
    else
      {:error, "File #{template_file_name} doesn't exists"}
    end
  end

  @doc """
  render_template/3 render the data using a carbone template
  """
  def render_template(template_id, finch_name, data) do
    result = send_data_to_renderer(finch_name, template_id, data)

    case result do
      {:ok, response} ->
        get_id_from_response(response)

      _ ->
        result
    end
  end

  @doc """
  get_document/2 get the 'final' file from the carbone service
  """
  def get_document(render_id, finch_name) do
    base_uri = get_carbone_serice_base_uri()
    api_token = get_api_token()

    headers = [
      {"Authorization", "Bearer #{api_token}"},
      {"carbone-version", get_carbone_version()}
    ]

    Finch.build(:get, "#{base_uri}/render/#{render_id}", headers)
    |> Finch.request(finch_name)
    |> case do
      {:ok, response} -> response.body
      _ -> nil
    end
  end

  @doc """
  response_succeeded?/1 check if the http request was sent successfuly AND if the carbone
  service has proceeded the request successfuly
  """
  def response_succeeded?(response) do
    case decode_json(response) do
      {:error, _} -> false
      {:ok, %{"success" => true}} -> true
      {:ok, %{"success" => false}} -> false
      _ -> false
    end
  end

  @doc """
  get_template_id_from_response/1 fetch the template_id from
  the response which is a map like:
  %Finch.Response{
    body: "{\"success\":true,\"data\":{\"templateId\":\"12345uMTEuMzAgICAgNQwu8xOLHsfcOSAcmVwb3J0\"}}",
    headers: [
      .....
    ],
    status: 200
  }
  """
  def get_id_from_response(response) do
    case response_succeeded?(response) do
      true -> extract_id_from_response(response)
      false -> response
    end
  end

  ## Private functions
  defp create_multipart(template_file_name) do
    if File.exists?(template_file_name) do
      Multipart.new()
      |> Multipart.add_part(Multipart.Part.file_field(template_file_name, :template))
    else
      {:error, "File #{template_file_name} doesn't exists"}
    end
  end

  defp decode_json(response) do
    Jason.decode(response.body)
  end

  defp send_data_to_renderer(finch_name, template_id, data) do
    base_uri = get_carbone_serice_base_uri()
    api_token = get_api_token()

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{api_token}"},
      {"carbone-version", get_carbone_version()}
    ]

    data
    |> Jason.encode(data)
    |> case do
      {:ok, value} ->
        Finch.build(:post, "#{base_uri}/render/#{template_id}", headers, value)
        |> Finch.request(finch_name)

      _ ->
        nil
    end
  end

  defp extract_id_from_response(response) do
    case decode_json(response) do
      {:ok, %{"data" => %{"templateId" => id}}} -> id
      {:ok, %{"data" => %{"renderId" => id}}} -> id
      _ -> nil
    end
  end

  defp get_api_token do
    System.get_env("CARBONE_TOKEN") ||
      raise """
      environment variable CARBONE_TOKEN is missing.
      """
  end

  defp get_carbone_version do
    System.get_env("CARBONE_VERSION") || "3"
  end

  defp get_carbone_serice_base_uri do
    System.get_env("CARBONE_BASE_URI") || "https://render.carbone.io"
  end
end
