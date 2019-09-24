defmodule GrapeyTest do
  use ExUnit.Case
  doctest Grapey

  import Tesla.Mock
  import TestFixtures

  import SweetXml

  setup do
    mock fn env -> 
      cond do
        env.url == "https://www.goodreads.com/hello" -> %Tesla.Env{status: 200, body: "<xml>hello</xml>"}
        Regex.match?(~r/shelf\/list/, env.url) -> %Tesla.Env{status: 200, body: fixture("shelves_list") }
        Regex.match?(~r/review\/list/, env.url) -> %Tesla.Env{status: 200, body: fixture("review_list") }
        true -> %Tesla.Env{status: 404, body: ""}
      end
    end
    :ok
  end

  test "hello" do
    assert {:ok, %Tesla.Env{} = env} = Grapey.get("/hello")
    assert env.status == 200
    inner = env.body 
            |> SweetXml.xpath(~x"/xml/text()")
    assert inner == 'hello'
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

  test "greets the world" do
    assert Grapey.hello() == :world
  end
end
