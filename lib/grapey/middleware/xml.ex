defmodule Grapey.Middleware.XML do
  @behaviour Tesla.Middleware

  import SweetXml

  def call(env, next, _) do
    with {:ok, env} <- Tesla.run(env, next) do
      body = parse(env.body, namespace_conformant: true)
      {:ok, %{env | body: body }}
    end
  end
end
