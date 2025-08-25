#!/bin/bash
flask db upgrade

exec "$@"
#test