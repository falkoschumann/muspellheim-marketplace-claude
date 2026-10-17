# Claude configuration
#CLAUDE_OPTS := --dry-run

# Make configuration
SHELL := /bin/bash

all: check

check:
	claude plugin validate .claude-plugin/marketplace.json
	prettier --check .

fix:
	prettier --write .

deploy:
	claude plugin tag plugins/muspellheim-shared $(CLAUDE_OPTS)
