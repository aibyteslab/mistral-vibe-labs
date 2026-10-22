#!/usr/bin/env python3
"""Vibe pre_tool hook: deny shell commands that name secret files.

A guard against accidents, not a sandbox: obfuscated commands can bypass it.
Reads the hook JSON on stdin; prints a deny decision or nothing.
"""
import json
import re
import sys

SECRET = re.compile(
    r"(^|[\s/'\"=<>|;&(])"
    r"(\.env(\.[\w.-]+)?(?!\w)|\.envrc|id_(rsa|ed25519|ecdsa)\b|[\w.-]+\.(pem|key)\b"
    r"|\.ssh/|\.gnupg/|/etc/shadow)",
    re.IGNORECASE,
)
EXAMPLE = re.compile(r"\.env\.example(?![\w.-])", re.IGNORECASE)


def main() -> int:
    try:
        data = json.load(sys.stdin)
    except ValueError:
        return 1  # strict = true turns this into a denial
    command = str((data.get("tool_input") or {}).get("command", ""))
    # Drop only the placeholder file's name, so "cat .env.example; cat .env"
    # is still caught.
    command = EXAMPLE.sub("", command)
    if SECRET.search(command):
        print(json.dumps({
            "decision": "deny",
            "reason": "Blocked by lab policy: shell commands may not read "
                      "secret files (.env, keys, ~/.ssh). Ask the user instead.",
        }))
    return 0


if __name__ == "__main__":
    sys.exit(main())
