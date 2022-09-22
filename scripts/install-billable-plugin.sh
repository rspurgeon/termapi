#!/bin/bash

dir=billable
plugin_dir=".plugins/kong-plugin-billable-1.0.1-4/kong/plugins/billable"

docker exec -it --user root kong-gateway mkdir -p /usr/local/share/lua/5.1/kong/plugins/$dir
docker cp $plugin_dir/. kong-gateway:/usr/local/share/lua/5.1/kong/plugins/$dir
docker exec --user kong -e KONG_PLUGINS="bundled,$dir" kong-gateway kong migrations up -vv
docker exec --user kong -e KONG_PLUGINS="bundled,$dir" kong-gateway kong reload -vv
