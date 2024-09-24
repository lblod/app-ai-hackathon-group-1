defmodule Dispatcher do
  use Matcher

  define_accept_types(
    html: ["text/html", "application/xhtml+html"],
    json: ["application/json", "application/vnd.api+json"],
    upload: ["multipart/form-data"],
    sparql_json: ["application/sparql-results+json"],
    any: ["*/*"]
  )

  define_layers([:api_services, :api, :frontend, :not_found])

  ###############################################################
  # domain.json
  ###############################################################

  match "/activities/*path", %{ accept: [:json], layer: :api} do
    Proxy.forward conn, path, "http://resource/activities/"
  end

  match "/annotations/*path", %{ accept: [:json], layer: :api} do
    Proxy.forward conn, path, "http://resource/annotations/"
  end

  match "/validations/*path", %{ accept: [:json], layer: :api} do
    Proxy.forward conn, path, "http://resource/validations/"
  end

  ###############################################################
  # frontend layer
  ###############################################################

  match "/assets/*path", %{layer: :api} do
    Proxy.forward(conn, path, "http://frontend/assets/")
  end

  match "/@appuniversum/*path", %{layer: :api} do
    Proxy.forward(conn, path, "http://frontend/@appuniversum/")
  end

  match "/*path", %{accept: [:html], layer: :api} do
    Proxy.forward(conn, [], "http://frontend/index.html")
  end

  match "/*_path", %{layer: :frontend} do
    Proxy.forward(conn, [], "http://frontend/index.html")
  end

  match "/groups/*path", %{accept: [:json], layer: :api} do
    Proxy.forward(conn, path, "http://resource/groups/")
  end

  ###############################################################
  # Not found
  ###############################################################
  match "/*_", %{accept: [:any], layer: :not_found} do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end
end
