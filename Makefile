BUILD_DIR := build

.PHONY: site
site:
	soupault

.PHONY: assets
assets:
	mkdir -p $(BUILD_DIR)
	cp -r assets/* assets/.well-known vendored/assets/* $(BUILD_DIR)/

.PHONY: all
all: site assets

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)/* $(BUILD_DIR)/.well-known

.PHONY: serve
serve:
	python3 -m http.server --directory $(BUILD_DIR)

.PHONY: deploy
deploy:
	git -C $(BUILD_DIR) add -A
	git -C $(BUILD_DIR) commit -m "latest build"
	git -C $(BUILD_DIR) push
