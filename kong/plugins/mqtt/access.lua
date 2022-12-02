-- Always use functions as locals variables
local kong = kong
local mqtt = require("mqtt")
local utils = require("kong.tools.utils")
local table_concat= table.concat
local ngx = ngx
local string_sub = string.sub

local _M = {}

local function create_mqtt_client(conf)
  local mqtt_client = mqtt.client{
    uri = conf.mqtt_host .. ":" .. conf.mqtt_port,
    username = conf.mqtt_username,
    password = conf.mqtt_password,
    clean = conf.mqtt_clean_session,
    ssl_module = conf.mqtt_ssl_enabled and "ssl" or nil,
    secure = conf.mqtt_ssl_enabled,
    version = conf.mqtt_version,
  }
  return mqtt_client
end


local function publish_message(mqtt_client, conf, msg_uuid)
  local mqtt_topic = conf.mqtt_topic
  if conf.path_as_topic then
    mqtt_topic = ngx.var.upstream_uri == "/" and "/" or string_sub(ngx.var.upstream_uri, 2)
  end
  local ok, err = mqtt_client:publish({
    topic = mqtt_topic,
    payload = kong.request.get_raw_body(),
    user_properties = {uuid = msg_uuid},
    qos = conf.mqtt_qos,
    retain = conf.mqtt_retain,
  })

  if not ok then
    local response_body = {message = "mqtt plugin failed to publish message to mqtt broker", err = err}
    kong.log.err(response_body)
    return {status = 500, body = response_body}
  end

  return {status = 200, body = {message = "mqtt plugin published message to mqtt broker", uuid = msg_uuid}}
end


function _M.execute(conf)
  local client = create_mqtt_client(conf)

  local ok, err = client:start_connecting()
  if not ok then
    local reponse_body = {message = "mqtt plugin failed to connect to mqtt broker", err = err}
    kong.log.err(table_concat(reponse_body))
    return kong.response.exit(500, reponse_body)
  end

  local msg_uuid = kong.request.get_header("x-request-id") or utils.uuid()

  local response = publish_message(client, conf, msg_uuid)

  client:disconnect()

  kong.response.exit(response.status, response.body)
end

return _M
