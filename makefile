generate:
	@rm -rf lovr/
	@mkdir lovr
	@mkdir lovr/library
	@luajit generator.lua

package: generate
	rm lovr.zip
	zip -9 -r lovr.zip lovr/
