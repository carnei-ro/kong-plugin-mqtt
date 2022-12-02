local typedefs = require "kong.db.schema.typedefs"
local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")

return {
  name = plugin_name,
  fields = {
    {
      config = {
        type = "record",
        fields = {
          {
            mqtt_host = typedefs.host{
              required = true
            }
          },
          {
            mqtt_port = typedefs.port{
              required = true,
              default = 1883
            }
          },
          {
            mqtt_topic = {
              type = "string",
              required = false
            }
          },
          {
            mqtt_username = {
              type = "string",
              required = false
            }
          },
          {
            mqtt_password = {
              type = "string",
              required = false
            }
          },
          {
            mqtt_clean_session = {
              type = "boolean",
              default = true,
              required = true
            }
          },
          {
            mqtt_ssl_enabled = {
              type = "boolean",
              default = false,
              required = true
            }
          },
          {
            mqtt_version = {
              type = "number",
              default = 4,
              required = true,
              one_of = {4, 5}
            }
          },
          {
            mqtt_qos = {
              type = "number",
              default = 0,
              required = true,
              one_of = {0, 1, 2}
            }
          },
          {
            mqtt_retain = {
              type = "boolean",
              default = false,
              required = true
            }
          },
          {
            path_as_topic = {
              type = "boolean",
              default = false,
              required = true
            }
          },
        },
      },
    },
  },
  entity_checks = {
    { conditional = {
        if_field = "config.path_as_topic",
        if_match = { eq = false },
        then_field = "config.mqtt_topic",
        then_match = { required = true },
    }, },
  },
}
