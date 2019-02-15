#!/bin/bash
sed -i "s|__TAG__|${1}|g" manifest.tmpl
