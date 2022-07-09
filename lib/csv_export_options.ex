defmodule Carbonex.CsvFormatOptions do
  @enforce_keys ~w(field_separator)a
  @enforce_keys ~w(text_delimiter)a
  @enforce_keys ~w(char_set)a

  # char_set 76 = utf8
  defstruct field_separator: "+", text_delimiter: '"', char_set: '76'
end
