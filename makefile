.PHONY: fetch-data

fetch-api:
	@command -v curl >/dev/null 2>&1 && \
		curl -o api.json https://lovr.org/api/data || \
		(command -v wget >/dev/null 2>&1 && \
		wget -O api.json https://lovr.org/api/data || \
		(echo "Error: Neither curl nor wget is available" && exit 1))

generate:
	@rm -rf lovr/
	@mkdir lovr
	@luajit generator.lua

package: generate
	zip -9 -r lovr.zip lovr/
