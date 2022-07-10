defmodule Carbonex do
  alias Carbonex.Environment
  alias Carbonex.RequestBody
  alias Carbonex.HttpHeaders

  @moduledoc """
  Documentation for `Carbonex`.

  `Carbonex` is a small library that help to create a document rendered by https://carbone.io
  """

  @doc """
  render/3 render a document based on a givem template
  and its data
  """
  def render(
        env = %Environment{},
        template_file_name,
        request_body = %RequestBody{}
      ) do
    add_template(env, template_file_name)
    |> render_template(env, request_body)
    |> get_document_data(env)
  end

  @doc """
  add_template/2 add a carbone template to the Carbone service
  """
  def add_template(env = %Environment{}, template_file_name) do
    if File.exists?(template_file_name) do
      multipart = create_multipart(template_file_name)
      body_stream = Multipart.body_stream(multipart)

      headers = HttpHeaders.from_environment_for_multipart(env, multipart)

      Finch.build(:post, "#{env.base_uri}/template", headers, {:stream, body_stream})
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
        env = %Environment{},
        req_body = %RequestBody{}
      ) do
    result = send_data_to_renderer(env, template_id, req_body)

    case result do
      {:ok, response} ->
        get_id_from_response(response)

      _ ->
        result
    end
  end

  @doc """
  get_document_data/2 get the 'final' file from the carbone service
  """
  def get_document_data(render_id, env = %Environment{}) do
    headers = HttpHeaders.from_environment(env)

    Finch.build(:get, "#{env.base_uri}/render/#{render_id}", headers)
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

  def create_file(
        env = %Environment{},
        template_file_name,
        request_body = %RequestBody{},
        file_name
      ) do
    render(env, template_file_name, request_body)
    |> to_file(file_name)
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
         env = %Environment{},
         template_id,
         req_body = %RequestBody{}
       ) do
    headers = HttpHeaders.from_environment(env)

    body = RequestBody.to_json(req_body)

    case body do
      {:ok, value} ->
        Finch.build(:post, "#{env.base_uri}/render/#{template_id}", headers, value)
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

  defp to_file(data, file_name) do
    File.write(file_name, data, [:write])
  end
end
