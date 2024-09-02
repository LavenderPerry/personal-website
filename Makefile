BUILD_DIR := build

.PHONY: site
site:
	soupault

.PHONY: assets
assets:
	cp -r assets/* vendored/assets/* $(BUILD_DIR)/

.PHONY: all
all: site assets

.PHONY: clean
clean:
	rm -r $(BUILD_DIR)
	mkdir $(BUILD_DIR)

.PHONY: serve
serve:
	python3 -m http.server --directory $(BUILD_DIR)
