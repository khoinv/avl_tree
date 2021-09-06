defmodule AvlTree.SameKeysError do
  @moduledoc false
  defexception message: "Equal keys are not allowed"
end
