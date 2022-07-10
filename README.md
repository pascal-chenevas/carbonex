[![Elixir CI](https://github.com/pascal-chenevas/carbonex/actions/workflows/elixir.yml/badge.svg?branch=main)](https://github.com/pascal-chenevas/carbonex/actions/workflows/elixir.yml)

# Carbonex

`Carbonex` is a small library that help to create a document rendered by https://carbone.io

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `carbonex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:carbonex, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
# set up the API-Token to use against the service for authorization
env = %Carbonex.Environment{token: "yor_token" }
```

The "raw"-data that must be rendered ([documentation](https://carbone.io/documentation.html#building-a-template))

```elixir
data = %{}
```
```elixir
# create a request body to send to the service 
req_body = %Carbonex.RequestBody{convert_to: "pdf", data: data}
```

```elixir
# send your data to the renderer sothat the service can generate the document
resp_content = Carbonex.render(env, "template/sample_template.odt", req_body)
```

or if you want directly to save the content to a file

```elixir
Carbonex.render(env, "template/sample_template.odt", req_body, "~/report.pdf")
```

# References

[Carbone.io](https://carbone.io) a report generator.

## Useful links

- [How to build a template file](https://carbone.io/documentation.html#building-a-template)

- [Substitutions](https://carbone.io/documentation.html#substitutions)

- [Repetitions](https://carbone.io/documentation.html#repetitions)

- [Formatters](https://carbone.io/documentation.html#formatters)

- [Translations](https://carbone.io/documentation.html#translations)

