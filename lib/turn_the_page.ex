defmodule TurnThePage do
  @moduledoc """
    Fast, simple and lightweight pagination system for your Elixir application.

    It works with queries and with lists. No magic applied.
  """
  import Ecto.Query

  @doc """
    It paginates the query or the list using Ecto.Query functions in case of query
    and Stream / Enum functions for list.

    Parameters:
      - name of the module, query or list
      - keyword list in format [page: page, limit: limit]
  """
  def paginate(_collection, [page: page, limit: _limit]) when page <= 0 do
    raise ArgumentError, message: "Page should be positive integer"
  end

  def paginate(_collection, [page: _page, limit: limit]) when limit <= 0 do
    raise ArgumentError, message: "Limit should be positive integer"
  end

  def paginate(module_name, [page: page, limit: limit]) when is_atom(module_name) do
    paginate(from m in module_name, [page: page, limit: limit])
  end

  def paginate(%Ecto.Query{} = query, [page: page, limit: limit]) do
    offset = (page - 1) * limit
    query
    |> offset(^offset)
    |> limit(^limit)
  end

  def paginate(list, [page: page, limit: limit]) when is_list(list) do
    list
    |> Stream.chunk(limit, limit, [])
    |> Enum.at(page - 1, [])
  end

  def paginate(_collection, [page: _page, limit: _limit]) do
    raise ArgumentError, message: "We can paginate only queries and lists"
  end
end
