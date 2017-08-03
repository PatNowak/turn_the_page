defmodule JobMessenger.TurnThePageTest do
  use ExUnit.Case, async: true

  test "paginate raises ArgumentError for negative page" do
    assert_raise ArgumentError, "Page should be positive integer", fn ->
      TurnThePage.paginate([1, 2, 3], page: -1, limit: 54)
    end
  end

  test "paginate raises ArgumentError for negative limit" do
    assert_raise ArgumentError, "Limit should be positive integer", fn ->
      TurnThePage.paginate([1, 2, 3], page: 12, limit: -3)
    end
  end

  test "paginate raises ArgumentError for not allowed collection" do
    assert_raise ArgumentError, "We can paginate only queries and lists", fn ->
      TurnThePage.paginate(%{}, page: 12, limit: 3)
    end
  end

  test "paginate raises ArgumentError for module without a schema" do
    assert_raise ArgumentError, "This module doesn't have schema!", fn ->
      TurnThePage.paginate(Enum, page: 12, limit: 3)
    end
  end

  test "paginate works no matter of order additional parameters" do
    assert TurnThePage.paginate([1, 2, 3], page: 1, limit: 2) == TurnThePage.paginate([1, 2, 3], limit: 2, page: 1)
  end

  test "paginate works with default parameters fine" do
    assert TurnThePage.paginate([1, 2, 3]) == TurnThePage.paginate([1, 2, 3], page: 1, limit: 20)
  end

  test "paginate for lists returns properly first page" do
    result = (1..100)
    |> Enum.to_list()
    |> TurnThePage.paginate(page: 1, limit: 12)
    assert Enum.count(result) == 12
  end

  test "paginate for lists returns properly last not full page" do
    result = (1..100)
    |> Enum.to_list()
    |> TurnThePage.paginate(page: 9, limit: 12)
    assert Enum.count(result) == 4 # 100 - 96
  end

  test "paginate for lists returns properly last empty page" do
    result = (1..100)
    |> Enum.to_list()
    |> TurnThePage.paginate(page: 100, limit: 12)
    assert Enum.count(result) == 0
  end
end
