defmodule GrapeyTest do
  use ExUnit.Case
  doctest Grapey

  # import Tesla.Mock

  test "list things" do
    assert Grapey.shelves(4320329) == %{shelves:
      [
        %{name: 'read'},
        %{name: 'currently-reading'},
        %{name: 'to-read'},
        %{name: 'letsremake-info'},
        %{name: 'olr-bookclub'},
        %{name: 'parents-children'},
        %{name: 'programming'}
      ]
    }
  end

  test "greets the world" do
    assert Grapey.hello() == :world
  end
end
