defmodule AuthServiceWeb.ErrorHelpers do
  @moduledoc """
  Provides helper functions for translating and building error messages.
  """

  def translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
