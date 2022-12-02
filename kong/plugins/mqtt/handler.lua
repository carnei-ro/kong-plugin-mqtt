local plugin_name = ({...})[1]:match("^kong%.plugins%.([^%.]+)")
local access = require("kong.plugins." .. plugin_name .. ".access") --not necessary to split the access in a separeted file


local plugin = {
  PRIORITY = 20, -- set the plugin priority, which determines plugin execution order
  VERSION = "0.1.0",
}


--[[ handles more initialization, but AFTER the worker process has been forked/created.
-- It runs in the 'init_worker_by_lua_block'
function plugin:init_worker()
  -- your custom code here
  kong.log.debug("saying hi from the 'init_worker' handler")
end
]]--

--[[ runs in the ssl_certificate_by_lua_block handler
function plugin:certificate(plugin_conf)
  -- your custom code here
  kong.log.debug("saying hi from the 'certificate' handler")
end
]]--

--[[ runs in the 'rewrite_by_lua_block'
-- IMPORTANT: during the `rewrite` phase neither `route`, `service`, nor `consumer`
-- will have been identified, hence this handler will only be executed if the plugin is
-- configured as a global plugin!
function plugin:rewrite(plugin_conf)
  -- your custom code here
  kong.log.debug("saying hi from the 'rewrite' handler")
end
]]--

---[[ runs in the 'access_by_lua_block'
function plugin:access(plugin_conf)
  -- executing the function "execute" in file required as "access"
  access.execute(plugin_conf)
end
--]]

--[[ Depends on Kong >= 2.2.x.
-- Using it automatically enables response buffering, which allows you to manipulate
--  both the response headers and the response body in the same phase
function plugin:response(plugin_conf)
  local response_body = kong.service.response.get_body()
  local status = kong.service.response.get_status()
  kong.response.set_header('foo', 'bar')
  kong.response.exit(202, {['request_body'] = request_body, ['response_body'] = response_body, ['status'] = status })
end
]]--


--[[ runs in the 'header_filter_by_lua_block'
function plugin:header_filter(plugin_conf)
  -- your custom code here, for example;
  ngx.header[plugin_conf.response_header] = "this is on the response"
end
]]--


--[[ runs in the 'body_filter_by_lua_block'
function plugin:body_filter(plugin_conf)
  -- your custom code here
  kong.log.debug("saying hi from the 'body_filter' handler")
end
]]--


--[[ runs in the 'log_by_lua_block'
function plugin:log(plugin_conf)
  -- your custom code here
  kong.log.debug("saying hi from the 'log' handler")
end
]]--


-- return our plugin object
return plugin
