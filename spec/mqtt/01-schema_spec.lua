local PLUGIN_NAME = "mqtt"

-- helper function to validate data against a schema
local validate do
  local validate_entity = require("spec.helpers").validate_plugin_config_schema
  local plugin_schema = require("kong.plugins."..PLUGIN_NAME..".schema")

  function validate(data)
    return validate_entity(data, plugin_schema)
  end
end


describe(PLUGIN_NAME .. ": (schema)", function()

  it("missing fileds", function()
    local ok, err = validate({
      })
    assert.is_nil(ok)
    assert.is_truthy(err)
    assert(string.find(err.config.mqtt_host, "required field missing", nil, true))
    assert(string.find(err.config.mqtt_topic, "required field missing", nil, true))
  end)

  it("conf ok", function()
    local ok, err = validate({
        mqtt_host = "emqx",
        mqtt_topic = "foo/bar/baz",
      })
    assert.is_nil(err)
    assert.is_truthy(ok)
  end)

  it("conf path as topic", function()
    local ok, err = validate({
        mqtt_host = "emqx",
        path_as_topic = true,
      })
    assert.is_nil(err)
    assert.is_truthy(ok)
  end)

end)
