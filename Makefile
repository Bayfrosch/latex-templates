# Copyright (C) 2026 Bayfrosch.
# This file is part of Bay templates and may be distributed and/or modified
# under the LaTeX Project Public License, version 1.3c or (at your option)
# any later version. The complete work is listed in LICENSE.md.
# See LICENSE for the full license text.

INPUT_DIR ?= import
OUTDIR ?= build/docker

.PHONY: all presentation animated handout documents
all presentation animated handout documents:
	@docker compose version || (echo "Docker Compose is required. See README.md Requirements for installation instructions." && exit 1)
	docker compose run --rm latex --input "$(INPUT_DIR)" --output "$(OUTDIR)" --target $@

