#!/bin/bash
# PERMANENT RULE for Isle of Six Crowns: nothing is pushed or written to GitHub more than once every 5 minutes.
# usage: gh_guard.sh <repo dir>   (pushes HEAD to origin main exactly once, after waiting out the 5 minute gap)
set -e; G=$1; GAP=300; STAMP=$G/.git/last_push_time; cd $G
git fetch -q origin main
REMOTE=$(git log -1 --format=%ct origin/main 2>/dev/null || echo 0)
LOCAL=$(cat $STAMP 2>/dev/null || echo 0)
LAST=$(( REMOTE > LOCAL ? REMOTE : LOCAL )); NOW=$(date +%s); WAIT=$(( LAST + GAP - NOW ))
if [ $WAIT -gt 0 ]; then echo "gh_guard: last GitHub write was $((NOW-LAST))s ago; waiting ${WAIT}s to keep the 5 minute rule"; sleep $((WAIT+5)); fi
# refuse to publish anything that looks like a secret
if git grep -I -n -E "GOCSPX-[A-Za-z0-9_-]{10,}|ghp_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{30,}|AKIA[0-9A-Z]{16}" HEAD -- . >/dev/null 2>&1 \
   || git ls-tree -r --name-only HEAD | grep -E "\.(neu|html)$" | while read f; do git show HEAD:"$f" | grep -a -q -E "GOCSPX-|ghp_[A-Za-z0-9]{30,}|github_pat_" && echo x; done | grep -q x; then
  echo "gh_guard: a secret was found in the files to publish. Nothing was pushed."; exit 3; fi
date +%s > $G/.git/guard_ok; date +%s > $STAMP; git push -q origin HEAD:main; date +%s > $STAMP
echo "gh_guard: pushed once at $(date -u +%H:%M:%SZ). Next push allowed after $(date -u -d @$(( $(date +%s)+GAP )) +%H:%M:%SZ)."
