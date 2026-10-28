#!/usr/bin/env bash

# Stop hook: runs `make check` when the agent finishes a task.
# - Exit 2 + stderr: tells Claude that `make check` failed, so it keeps working.
# - Exit 0 + systemMessage: informs the user without blocking.

# jq is required to parse the hook input and to build JSON messages
if ! command -v jq >/dev/null 2>&1; then
  echo '{"systemMessage": "Hook make-check.sh: jq not found, make check was skipped."}'
  exit 0
fi

input=$(cat)

# Avoid an endless loop: Claude was already sent back to work by this hook
if [[ "$(echo "$input" | jq -r '.stop_hook_active // false')" == "true" ]]; then
  exit 0
fi

# Start from the session's working directory, then move to the root of the
# current git worktree (not the main checkout). Outside git, use project root or
# stay in cwd.
dir=$(echo "$input" | jq -r '.cwd // empty')
cd "${dir:-${CLAUDE_PROJECT_DIR:-.}}" || exit 0
root=$(git rev-parse --show-toplevel 2>/dev/null)
if [[ -n "$root" ]]; then
  cd "$root" || exit 0
fi

# Shell function: non-blocking message to the user, then exit 0
notify() {
  jq -n --arg m "$1" '{systemMessage: $m}'
  exit 0
}

# Skip silently if the git worktree has no changes
# (outside a git repository the check still runs)
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  if [[ -z "$(git status --porcelain)" ]]; then
    exit 0
  fi
fi

# Can `make check` be processed at all? Question mode does not run the recipe.
# Exit 0/1 = target is processable, 2 = error (missing target, broken Makefile, ...)
probe_output=$(make -q check 2>&1)
probe_status=$?
if [[ $probe_status -ge 2 ]]; then
  notify "Hook make-check.sh: 'make check' cannot be run in $PWD, so it was skipped. Make said: $(tail -n 5 <<<"$probe_output")"
fi

output=$(make check 2>&1)
status=$?

if [[ $status -ne 0 ]]; then
  {
    echo "Hook make-check.sh: 'make check' failed in $PWD (exit $status). Last output:"
    echo "$output" | tail -n 60
    echo "Please fix the errors and run 'make check' again."
  } >&2
  exit 2
fi

notify "Hook make-check.sh: make check passed in $PWD."
