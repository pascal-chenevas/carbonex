defmodule CarbonexTest do
  use ExUnit.Case
  doctest Carbonex

  test "response_succeeded? is false when body is empty" do
   response = %{
      body: "",
      headers: [ ],
      status: 200
    }

    assert Carbonex.response_succeeded?(response) === false
  end

  test "response_succeeded? is true when body is not empty" do
   response = %{
      body: "{\"success\":true,\"data\":{\"templateId\":\"12345uMTEuMzAgICAgNQwu8xOLHsfcOSAcmVwb3J0\"}}",
      headers: [ ],
      status: 200
    }

    assert Carbonex.response_succeeded?(response) === true
  end

  test "response_succeeded? is false when body is not empty" do
   response = %{
      body: "{\"success\":false,\"data\":{\"templateId\":\"12345uMTEuMzAgICAgNQwu8xOLHsfcOSAcmVwb3J0\"}}",
      headers: [ ],
      status: 200
    }

    assert Carbonex.response_succeeded?(response) === false
  end
  
  test "get the template_id from a response succeed" do
   response = %{
      body: "{\"success\":true,\"data\":{\"templateId\":\"12345uMTEuMzAgICAgNQwu8xOLHsfcOSAcmVwb3J0\"}}",
      headers: [ ],
      status: 200
    }

    assert Carbonex.get_template_id_from_response(response) === "12345uMTEuMzAgICAgNQwu8xOLHsfcOSAcmVwb3J0"
  end

  test "get the template_id from a response is nil" do
   response = %{
      body: "{\"success\":true,\"data\":{\"templated\":\"12\"}}",
      headers: [ ],
      status: 200
    }

    assert Carbonex.get_template_id_from_response(response) === nil
  end

  test "get the render_id from a response succeed" do
    response = %{
      body: "{\"success\":true,\"data\":{\"renderId\":\"MTAuMjAuMTEuMzAgICAgNQwu8xyyJah9JOLHsfcOSAcmVwb3J0.pdf\"}}",
      headers: [ ],
      status: 200
    }

    assert Carbonex.get_render_id_from_response(response) === "MTAuMjAuMTEuMzAgICAgNQwu8xyyJah9JOLHsfcOSAcmVwb3J0.pdf"
  end

  test "get the render_id from a response is nil" do
   response = %{
      body: "{\"success\":true,\"data\":{}}",
      headers: [ ],
      status: 200
    }

    assert Carbonex.get_template_id_from_response(response) === nil
  end
  
end
