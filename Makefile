BUILD_DIR := build

.PHONY: site
site:
	soupault

.PHONY: assets
assets:
	mkdir -p $(BUILD_DIR)
	cp -r assets/* vendored/assets/* $(BUILD_DIR)/

.PHONY: all
all: site assets

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)/* $(BUILD_DIR)/.well-known

.PHONY: serve
serve:
	python3 -m http.server --directory $(BUILD_DIR)
