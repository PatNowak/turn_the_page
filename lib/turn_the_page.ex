defmodule TurnThePage do
  @moduledoc """
    Fast, simple and lightweight pagination system for your Elixir application.

    It works with queries and with lists. No magic applied.
  """
  import Ecto.Query

  @doc """
    It paginates the query or the list using Ecto.Query functions in case of query
    and Stream / Enum functions for list and returns the query.

    Parameters:
      name of the module, query or list
      opts

    Possible options are:
      page - by default 1
      limit - by default 20

    It returns Ecto.Query so to use is to have to apply at the end:
      Repo.all()
  """
  @spec paginate(Ecto.Query.t | [] | atom, [page: number, limit: number]) :: Ecto.Query.t
  def paginate(collection, opts \\ [])
  def paginate(module, opts) when is_atom(module) do
    module = module
    |> validate_module()
    paginate(from(m in module), opts)
  end

  def paginate(%Ecto.Query{} = query, opts) do
    %{page: page, limit: limit} = validate_options(opts)

    offset = (page - 1) * limit
    query
    |> offset(^offset)
    |> limit(^limit)
  end

  def paginate(list, opts) when is_list(list) do
    %{page: page, limit: limit} = validate_options(opts)

    list
    |> Stream.chunk(limit, limit, [])
    |> Enum.at(page - 1, [])
  end

  def paginate(_collection, [page: _page, limit: _limit]) do
    raise ArgumentError, message: "We can paginate only queries and lists"
  end

  defp validate_module(module) do
    has_schema? = module
    |> apply(:module_info, [:exports])
    |> Keyword.get(:__schema__)

    if has_schema? do
      module
    else
      raise ArgumentError, message: "This module doesn't have schema!"
    end
  end

  defp validate_options(options) do
    page =
      options
      |> Keyword.get(:page, 1)
      |> validate_page()

    limit =
      options
      |> Keyword.get(:limit, 20)
      |> validate_limit()

    page = case is_number(page) do
      true -> page
      false -> String.to_integer(page)
    end

    limit = case is_number(limit) do
      true -> page
      false -> String.to_integer(limit)
    end

    %{page: page, limit: limit}
  end

  defp validate_page(page) when is_number(page) do
    if page < 1 do
      raise ArgumentError, message: "Page should be positive integer"
    else
      page
    end
  end

  defp validate_page(_page) do
    raise ArgumentError, message: "Page should be positive integer"
  end

  defp validate_limit(limit) when is_number(limit) do
    if limit < 1 do
      raise ArgumentError, message: "Limit should be positive integer"
    else
      limit
    end
  end

  defp validate_limit(_limit) do
    raise ArgumentError, message: "Limit should be positive integer"
  end
end
