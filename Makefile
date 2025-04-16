include ftp_password.mk # Defines FTP_PASSWORD

BUILD_DIR := build
SSG := soupault

FTP_HOST := ftp.nekoweb.org:30000
FTP_USER := lavender

export FTP_HOST FTP_USER FTP_PASSWORD BUILD_DIR # For deploy

.PHONY: all
all: site assets

.PHONY: site
site:
	$(SSG)

.PHONY: assets
assets:
	mkdir -p $(BUILD_DIR)
	cp -r assets/* assets/.well-known $(BUILD_DIR)/

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)/* $(BUILD_DIR)/.well-known 

.PHONY: serve
serve:
	python3 -m http.server --directory $(BUILD_DIR)

.PHONY: deploy
deploy:
	./deploy.sh
