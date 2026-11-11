INPUT_DIR ?= import
OUTDIR ?= build

.PHONY: all presentation animated handout documents
all presentation animated handout documents:
	python3 scripts/build.py --input "$(INPUT_DIR)" --output "$(OUTDIR)" --target $@

