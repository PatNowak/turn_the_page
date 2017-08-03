# TurnThePage

**Fast, simple and lightweight pagination system for your Elixir application.**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `turn_the_page` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:turn_the_page, "~> 0.1.0"}
  ]
end
```

## Usage

Usage is very simple. All you need to is apply it in your DB pipeline.

It works with Module's name, Ecto.Query and regular lists.

### Example
```elixir
User
|> TurnThePage.paginate(page: 2, limit: 15) # it returns Ecto.Query
|> Repo.all()
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/turn_the_page](https://hexdocs.pm/turn_the_page).
