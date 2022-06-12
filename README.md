# Carbonex

**TODO: Add description**

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
request_body = %{"convertTo" => "pdf", "data" => data}

Carbonex.add_template(finch_name, template_file_name)
|> Carbonex.render_template(finch_name, request_body)
|> Carbonex.get_document(finch_name)
```
