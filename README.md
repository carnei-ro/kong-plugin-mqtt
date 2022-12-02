# Kong Plugin MQTT

summary: Send request body to MQTT Topic

<!-- BEGINNING OF KONG-PLUGIN DOCS HOOK -->
## Plugin Priority

Priority: **20**

## Plugin Version

Version: **0.1.0**

## Config

| name | type | required | validations | default |
|-----|-----|-----|-----|-----|
| mqtt_host | string | <pre>true</pre> |  |  |
| mqtt_port | integer | <pre>true</pre> | <pre>- between:<br/>  - 0<br/>  - 65535</pre> | <pre>1883</pre> |
| mqtt_topic | string | <pre>false</pre> |  |  |
| mqtt_username | string | <pre>false</pre> |  |  |
| mqtt_password | string | <pre>false</pre> |  |  |
| mqtt_clean_session | boolean | <pre>true</pre> |  | <pre>true</pre> |
| mqtt_ssl_enabled | boolean | <pre>true</pre> |  | <pre>false</pre> |
| mqtt_version | number | <pre>true</pre> | <pre>- one_of:<br/>  - 4<br/>  - 5</pre> | <pre>4</pre> |
| mqtt_qos | number | <pre>true</pre> | <pre>- one_of:<br/>  - 0<br/>  - 1<br/>  - 2</pre> | <pre>0</pre> |
| mqtt_retain | boolean | <pre>true</pre> |  | <pre>false</pre> |
| path_as_topic | boolean | <pre>true</pre> |  | <pre>false</pre> |

## Usage

```yaml
plugins:
  - name: mqtt
    enabled: true
    config:
      mqtt_host: ''
      mqtt_port: 1883
      mqtt_topic: ''
      mqtt_username: ''
      mqtt_password: ''
      mqtt_clean_session: true
      mqtt_ssl_enabled: false
      mqtt_version: 4
      mqtt_qos: 0.0
      mqtt_retain: false
      path_as_topic: false

```
<!-- END OF KONG-PLUGIN DOCS HOOK -->
