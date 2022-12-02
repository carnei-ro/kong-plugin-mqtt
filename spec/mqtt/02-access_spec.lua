local helpers = require "spec.helpers"

local cjson = require("cjson")

local PLUGIN_NAME = "mqtt"


for _, strategy in helpers.all_strategies() do if strategy ~= "cassandra" then
  describe(PLUGIN_NAME .. ": (access) [#" .. strategy .. "]", function()
    local client

    lazy_setup(function()

      local bp = helpers.get_db_utils(strategy == "off" and "postgres" or strategy, nil, { PLUGIN_NAME })

      -- Inject a test route. No need to create a service, there is a default
      -- service which will echo the request.
      local route1 = bp.routes:insert({
        hosts = { "test1.com" },
      })
      -- add the plugin to test to the route we created
      bp.plugins:insert {
        name = PLUGIN_NAME,
        route = { id = route1.id },
        config = {
          mqtt_host = "emqx",
          mqtt_topic = "foo/bar/baz",
        },
      }

      -- helpers.setenv('KONG_MYPLUGIN_SOMEDATA', '{"foo":"bar","baz":"johndoe"}')

      -- start kong
      assert(helpers.start_kong({
        -- set the strategy
        database   = strategy,
        -- use the custom test template to create a local mock server
        nginx_conf = "spec/fixtures/custom_nginx.template",
        -- make sure our plugin gets loaded
        plugins = "bundled," .. PLUGIN_NAME,
        -- write & load declarative config, only if 'strategy=off'
        declarative_config = strategy == "off" and helpers.make_yaml_file() or nil,
      }))
    end)

    lazy_teardown(function()
      helpers.stop_kong(nil, true)
    end)

    before_each(function()
      client = helpers.proxy_client()
    end)

    after_each(function()
      if client then client:close() end
    end)


    describe("response", function()
      it("post message", function()
        local r = client:post("/", {
          headers = {
            ['Host'] = "test1.com",
            ["X-Request-ID"] = "0ee16678-7248-11ed-8d69-57964a4282e5",
          },
          body = cjson.encode({
            message = "hello world"
          })
        })
        -- validate that the request succeeded, response status 200
        local body = assert.response(r).has.status(200)
        local json_body = cjson.decode(body)
        -- validate the value of uuid field
        assert.equal("0ee16678-7248-11ed-8d69-57964a4282e5", json_body['uuid'])
        assert.equal("mqtt plugin published message to mqtt broker", json_body['message'])
      end)
    end)

  end)
end end
