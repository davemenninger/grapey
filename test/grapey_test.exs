defmodule GrapeyTest do
  use ExUnit.Case
  doctest Grapey

  import Tesla.Mock
  import TestFixtures

  setup do
    mock fn env -> 
      cond do
        Regex.match?(~r/shelf\/list/, env.url) -> %Tesla.Env{status: 200, body: fixture("shelves_list") }
        Regex.match?(~r/review\/list.*page=2/, env.url) -> %Tesla.Env{status: 200, body: fixture("review_list_page_2") }
        Regex.match?(~r/review\/list/, env.url) -> %Tesla.Env{status: 200, body: fixture("review_list") }
        true -> %Tesla.Env{status: 404, body: ""}
      end
    end
    :ok
  end

  test "list shelves" do
    assert Grapey.shelves(user_id: 4_320_329) == %{shelves:
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
    %{
      total: total,
      books: _books,
      start_num: start_num,
      end_num: end_num
    } = Grapey.reviews(%{id: 4_320_329, shelf: "currently-reading"})

    assert total == 18
    assert start_num == 1
    assert end_num == 18
  end

  test "list page 2 reviews" do
    %{
      total: total,
      books: books,
      start_num: start_num,
      end_num: end_num
    } = Grapey.reviews(%{id: 4_320_329, shelf: "olr-bookclub", page: 2})
    assert total == 28
    assert start_num == 21
    assert end_num == 28
    assert Enum.count(books) == 8
  end
end
