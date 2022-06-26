defmodule Carbonex do
  @moduledoc """
  Documentation for `Carbonex`.

  `Carbonex` is a small library that help to create a document rendered by https://carbone.io
  """

  @doc """
  render/3 render a document based on a givem template
  and its data
  """
  def render(
        environement = %Carbonex.Environment{},
        template_file_name,
        request_body = %Carbonex.RequestBody{}
      ) do
    add_template(environement, template_file_name)
    |> render_template(environement, request_body)
    |> get_document(environement)
  end

  @doc """
  add_template/2 add a carbone template to the Carbone service
  """
  def add_template(environement = %Carbonex.Environment{}, template_file_name) do
    if File.exists?(template_file_name) do
      multipart = create_multipart(template_file_name)
      body_stream = Multipart.body_stream(multipart)
      content_length = Multipart.content_length(multipart)
      content_type = Multipart.content_type(multipart, "multipart/form-data")

      headers = [
        {"Content-Type", content_type},
        {"Content-Length", to_string(content_length)},
        {"Authorization", "Bearer #{environement.token}"},
        {"carbone-version", environement.version}
      ]

      Finch.build(:post, "#{environement.base_uri}/template", headers, {:stream, body_stream})
      |> Finch.request(CarboneHttp)
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
  def render_template(
        template_id,
        environment = %Carbonex.Environment{},
        req_body = %Carbonex.RequestBody{}
      ) do
    result = send_data_to_renderer(environment, template_id, req_body)

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
  def get_document(render_id, environment = %Carbonex.Environment{}) do
    headers = [
      {"Authorization", "Bearer #{environment.token}"},
      {"carbone-version", environment.version}
    ]

    Finch.build(:get, "#{environment.base_uri}/render/#{render_id}", headers)
    |> Finch.request(CarboneHttp)
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
    Multipart.new()
    |> Multipart.add_part(Multipart.Part.file_field(template_file_name, :template))
  end

  defp decode_json(response) do
    Jason.decode(response.body)
  end

  defp send_data_to_renderer(
         environment = %Carbonex.Environment{},
         template_id,
         req_body = %Carbonex.RequestBody{}
       ) do
    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{environment.token}"},
      {"carbone-version", environment.version}
    ]

    body = Carbonex.RequestBody.to_json(req_body)

    case body do
      {:ok, value} ->
        Finch.build(:post, "#{environment.base_uri}/render/#{template_id}", headers, value)
        |> Finch.request(CarboneHttp)

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
end
