defmodule GrapeyTest do
  use ExUnit.Case
  doctest Grapey

  import Tesla.Mock
  import TestFixtures

  setup do
    mock fn env -> 
      cond do
        Regex.match?(~r/shelf\/list/, env.url) -> %Tesla.Env{status: 200, body: fixture("shelves_list") }
        Regex.match?(~r/review\/list/, env.url) -> %Tesla.Env{status: 200, body: fixture("review_list") }
        true -> %Tesla.Env{status: 404, body: ""}
      end
    end
    :ok
  end

  test "list shelves" do
    assert Grapey.shelves(4_320_329) == %{shelves:
      [
        %{name: 'read'},
        %{name: 'currently-reading'},
        %{name: 'to-read'},
        %{name: 'galley'},
        %{name: 'young-adult'}
      ]
    }
  end

  test "list books" do
    %{total: total, books: _books} = Grapey.reviews(4_320_329, 'currently-reading')
    assert total == 18
  end
end
