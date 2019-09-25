defmodule Grapey do
  @moduledoc """
  Documentation for Grapey.
  """

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://www.goodreads.com"
  # plug Tesla.Middleware.Logger
  plug Grapey.Middleware.XML

  import SweetXml

  def api_key do
    System.get_env("GRAPEY_KEY") || "ro5ooiSoUzSmBbwjQbw"
  end

  def shelves(user_id: user_id) do
    {:ok, response} = get("shelf/list.xml?key=#{api_key()}&user_id=#{user_id}", opts: [adapter: hackney_opts()] )
    response.body
    |> xmap(shelves: [~x"//user_shelf"l,
      name: ~x"./name/text()"
    ])
  end

  def reviews(%{id: _user_id, shelf: _shelf} = params) do
    query_string = Map.merge(%{key: api_key(), v: 2}, params)
    |> URI.encode_query

    {:ok, response} = get("review/list?" <> query_string, opts: [adapter: hackney_opts()]  )

    response.body
    |> xmap(books: [~x"//review/book"l,
      title: ~x"./title/text()"
    ],
      total: ~x"//reviews/@total"i,
      start_num: ~x"//reviews/@start"i,
      end_num: ~x"//reviews/@end"i
      )
  end

  defp hackney_opts do
    case System.get_env("PROXY_HOST") do
      nil -> []
      _ -> [
          proxy: {
            String.to_charlist(System.get_env("PROXY_HOST")),
            String.to_integer(System.get_env("PROXY_PORT"))
          }
        ]
    end
  end
end
