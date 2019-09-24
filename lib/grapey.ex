defmodule Grapey do
  @moduledoc """
  Documentation for Grapey.
  """
  import SweetXml

  use Tesla

  adapter Tesla.Adapter.Hackney, proxy: {'proxy.whapps.internal', 8192}

  plug Tesla.Middleware.BaseUrl, "https://www.goodreads.com"
  plug Grapey.Middleware.XML

  @doc """
  Hello world.

  ## Examples

      iex> Grapey.hello()
      :world

  """
  def hello do
    :world
  end

  @gr_key "ro5ooiSoUzSmBbwjQbw"

  def shelves(user_id) do
    get("shelf/list.xml?key=#{@gr_key}&user_id=#{user_id}" )
    |> xmap(shelves: [ ~x"//user_shelf"l,
      name: ~x"./name/text()"
    ])
  end
end

defmodule Grapey.Middleware.XML do
  @behaviour Tesla.Middleware

  import SweetXml

  def call(env, next, _) do
    with {:ok, env} <- Tesla.run(env, next) do
      parse(env.body, namespace_conformant: true)
    end
  end
end
