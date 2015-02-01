#!/bin/bash

set -eu

render-templates.sh /data/sites-templates /data/sites-enabled
exec $@
