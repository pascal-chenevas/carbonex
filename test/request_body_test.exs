defmodule CarbonexRequestBodyTest do
  use ExUnit.Case
  doctest Carbonex.RequestBody

  test "camelize_keys : convert_to: value given is a string" do
    request_body = %Carbonex.RequestBody{convert_to: "xlsx", data: %{}}

    assert Carbonex.RequestBody.camelize_keys(request_body) === %{
             "convertTo" => "xlsx",
             "data" => %{}
           }
  end

  # test "camelize_keys : convert_to: value given is a struct" do
  #   format_options = %{field_separator: "+", text_delimiter: "\"", character_set: "76"}
  #   request_body = %Carbonex.RequestBody{convert_to: %{format_name: "xlsx", format_options: format_options}, data: %{}}
  #   assert Carbonex.RequestBody.camelize_keys(request_body) === %{"convertTo" => %{}, "data" => %{}}
  # end

  test "to_json : convert the struct to json " do
    request_body = %Carbonex.RequestBody{convert_to: "pdf", data: %{"key" => "value"}}

    assert Carbonex.RequestBody.to_json(request_body) ===
             {:ok, "{\"convertTo\":\"pdf\",\"data\":{\"key\":\"value\"}}"}
  end
end
