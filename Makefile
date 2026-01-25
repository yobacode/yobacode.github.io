.PHONY: build clean

BUILD_TIME := $(shell date +"%Y%m%d")
GIT_COMMIT_PARENT := $(shell git rev-parse --short HEAD 2>/dev/null || echo "nogit")
GIT_BRANCH := $(shell git branch --show-current 2>/dev/null || echo "unknown")
BUILD_INFO_FILE := docs/build-$(BUILD_TIME)-$(GIT_COMMIT_PARENT).txt

all: clean build buildinfo firefox

build:
	rm -rf docs/*
	find src -type f -name "*.html" -o -name "*.css" -o -name "*.js" | while read file; do \
		dest="docs/$${file#src/}"; \
		mkdir -p "$$(dirname "$$dest")"; \
		minify -o "$$dest" "$$file"; \
	done
	cp -r resources/* docs/

buildinfo:
	@echo "commit_parent: $(GIT_COMMIT_PARENT)" >  $(BUILD_INFO_FILE)
	@echo "branch: $(GIT_BRANCH)" >> $(BUILD_INFO_FILE)
	@echo "build_id: $(BUILD_TIME)" >> $(BUILD_INFO_FILE)
	@echo "created $(BUILD_INFO_FILE)"

firefox:
	firefox docs/index.html

clean:
	rm -rf docs/*
