defmodule AvlTree do
  @moduledoc """
  Simple implement of the AVL tree.
  """
  defstruct key: 0, value: nil, left: nil, right: nil, height: 1

  def insert(nil, key, value), do: %__MODULE__{key: key, value: value}

  def insert(%__MODULE__{} = node, key, value) do
    cond do
      key > node.key -> %{node | right: insert(node.right, key, value)}
      key < node.key -> %{node | left: insert(node.left, key, value)}
      true -> raise AvlTree.SameKeysError
    end
    |> re_calculate_height
    |> re_balance(key)
  end

  def print(nil), do: []

  def print(%__MODULE__{} = node) do
    [node.key] ++ print(node.left) ++ print(node.right)
  end

  def print(_) do
    raise ArgumentError, "Supports only type of nil or #{inspect(__MODULE__)}"
  end

  defp height(nil), do: 0

  defp height(%__MODULE__{} = node) do
    1 + max(height(node.left), height(node.right))
  end

  defp re_calculate_height(%__MODULE__{} = node) do
    %{node | height: height(node)}
  end

  defp get_balance(nil), do: 0

  defp get_balance(%__MODULE__{left: left, right: right}) do
    height(left) - height(right)
  end

  #       y                               x
  #      / \     Right Rotation          /  \
  #     x   t3   - - - - - - - >        t1   y
  #    / \       < - - - - - - -            / \
  #  t1  t2     Left Rotation            t2  t3
  defp right_rotate(%__MODULE__{left: %__MODULE__{left: t1, right: t2} = x, right: t3} = y) do
    %{x | left: t1, right: %{y | left: t2, right: t3}}
  end

  defp left_rotate(%__MODULE__{left: t1, right: %__MODULE__{left: t2, right: t3} = y} = x) do
    %{y | left: %{x | left: t1, right: t2}, right: t3}
  end

  defp re_balance(%__MODULE__{} = node, key) do
    balance = get_balance(node)

    cond do
      # Left Left Case
      # Left Right Case
      balance > 1 ->
        if key < node.left.key,
          do: right_rotate(node),
          else: right_rotate(%{node | left: left_rotate(node.left)})

      # Right Right Case
      # Right Left Case
      balance < -1 ->
        if key > node.right.key,
          do: left_rotate(node),
          else: left_rotate(%{node | right: right_rotate(node.right)})

      true ->
        node
    end
  end
end
