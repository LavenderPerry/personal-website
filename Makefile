BUILD_DIR := build
SSG := soupault

.PHONY: site
site:
	$(SSG)

.PHONY: assets
assets:
	mkdir -p $(BUILD_DIR)
	cp -r assets/* assets/.well-known $(BUILD_DIR)/

.PHONY: all
all: site assets

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)/* $(BUILD_DIR)/.well-known 

.PHONY: serve
serve:
	python3 -m http.server --directory $(BUILD_DIR)
