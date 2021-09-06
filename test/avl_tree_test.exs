defmodule AvlTreeTest do
  use ExUnit.Case

  test "inserts into tree correctly" do
    tree =
      Enum.reduce([10, 20, 30, 40, 50, 25], nil, fn key, tree ->
        AvlTree.insert(tree, key, nil)
      end)

    assert AvlTree.print(tree) == [30, 20, 10, 25, 40, 50]
  end

  test "inserts equal keys are not allowed" do
    assert_raise AvlTree.SameKeysError, fn ->
      Enum.reduce([10, 20, 20, 40, 50, 25], nil, fn key, tree ->
        AvlTree.insert(tree, key, nil)
      end)
    end
  end

  test "print/1 support only nil or #{inspect(AvlTree)} type inputs" do
    assert AvlTree.print(nil) == []
    assert AvlTree.print(AvlTree.insert(nil, 0, 1)) == [0]

    assert_raise ArgumentError, ~r/^Supports only type of nil or #{inspect(AvlTree)}$/, fn ->
      AvlTree.print(%{})
    end
  end
end
