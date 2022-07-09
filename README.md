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

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/carbonex>.

## Usage

```elixir
request_body = %{convert_to: => "pdf", data: data}
Carbonex.create(finch_name, "path/to/template.odt", request_body)
```
