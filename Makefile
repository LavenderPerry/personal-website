include ftp_password.mk # Defines FTP_PASSWORD

BUILD_DIR := build
SSG := soupault

FTP_HOST := ftp.nekoweb.org:30000
FTP_USER := lavender

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
	lftp $(FTP_HOST) -u $(FTP_USER),$(FTP_PASSWORD) -e "
		set net:timeout 60;
		set net:max-retries 20;
		set net:reconnect-interval-multiplier 2;
		set net:reconnect-interval-base 5;
		set ftp:ssl-force false; 
		set sftp:auto-confirm yes;
		set ssl:verify-certificate false; 
		mirror -v -P 5 -R -n -L -p $(BUILD_DIR) /;
		quit
	"
