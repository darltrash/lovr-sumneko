generate:
	@rm -rf lovr/
	@mkdir lovr
	@luajit generator.lua

package: generate
	rm lovr.zip
	zip -9 -r lovr.zip lovr/
