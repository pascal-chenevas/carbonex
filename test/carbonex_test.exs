defmodule CarbonexTest do
  use ExUnit.Case
  doctest Carbonex
  
  test "get the template_id from a response" do
   response = %{
      body: "{\"success\":true,\"data\":{\"templateId\":\"12345uMTEuMzAgICAgNQwu8xOLHsfcOSAcmVwb3J0\"}}",
      headers: [ ],
      status: 200
    }

    assert Carbonex.get_template_id_from_response(response) === "12345uMTEuMzAgICAgNQwu8xOLHsfcOSAcmVwb3J0"
  end

  test "get the render_id from a response" do
    response = %{
      body: "{\"success\":true,\"data\":{\"renderId\":\"MTAuMjAuMTEuMzAgICAgNQwu8xyyJah9JOLHsfcOSAcmVwb3J0.pdf\"}}",
      headers: [ ],
      status: 200
    }

    assert Carbonex.get_render_id_from_response(response) === "MTAuMjAuMTEuMzAgICAgNQwu8xyyJah9JOLHsfcOSAcmVwb3J0.pdf"
  end

  
end
