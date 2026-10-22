# Mistral Vibe: secure setup

Companion files for the AI Bytes Lab video *Mistral Vibe Part 2: lock it down*.
Tested with Mistral Vibe 3.0.1.

## Layers

| Layer | File | What it does |
|---|---|---|
| Agent | `user/config.toml` | `default_agent = "ask"`: every tool call asks first |
| Tool lists | `user/config.toml` | `.env`, keys and shell reads of secrets are on the deny lists |
| Hook | `user/hooks.toml` + `user/hooks/deny-secret-reads.py` | `pre_tool` hook refuses shell commands that name secret files, including chained ones (`cat a; cat .env`) |
| Instructions | `user/AGENTS.md` | Tells the model the rules (a hint, not a control) |
| Admin | `admin/managed-config.toml` | Workspace admin config: no auto-approve, no MCP |
| Trust | (dialog) | Untrusted repos keep their `.vibe/` config ignored |

See `lab/hardening/LAYERS.txt` and `lab/hardening/BEFORE-AFTER.txt`.

## Install

```bash
cd part2-secure-setup
./scripts/install.sh          # backs up existing files to *.bak-<stamp>, installs into ~/.vibe
./scripts/install.sh --lab    # also creates ~/vibe-lab with a demo app and an untrusted repo
./scripts/verify.sh           # checks modes, config entries, and that no API key is exported
```

The lab `.env` contains fake values only. Never put a real key in it.

Store your API key with `vibe --setup` (system keyring). Do not export
`MISTRAL_API_KEY` in your shell profile.

## Tested caveats (3.0.1)

- On first start Vibe 3 runs the migration `bash_read_only_defaults_v1`,
  which adds read-only commands such as `cat` to your bash allowlist.
  `config.toml` lists it under `applied_migrations` so your allowlist stays as written.
- A deny list match wins over the allow list.
- `vibe --yolo` skips the prompts **and** the deny lists. Only the `pre_tool`
  hook still fires, and it covers shell commands, not `read_file`. Block
  `--yolo` with `enable_auto_approve = false` in admin config.
- With that admin config, `vibe --yolo` starts in `ask`, prompts stay on,
  and Shift+Tab offers only `ask` and `accept edits`. 3.0.1 shows no
  warning about the ignored flag. `/config` shows the admin values but not
  where they come from.
- `disabled_agents` may be rewritten as a multi-line array. Edit it as a
  whole: deleting only its first line breaks `config.toml`.
- The 3.0.1 unified harness has no `grep` or `web_fetch` tool, so those
  blocks are inert there. `/config` does not list `[tools.*]` sections:
  test each block with a prompt.
- `*/.env.*` on the read_file deny list also blocks `.env.example`.
- In the session view, collapsed rows read "Ran …" / "Read …" even when the
  call was denied. Expand the row to see the result.
- The trust dialog highlights "Trust folder". Declining shows no warning,
  and Vibe asks again on the next start.

## Admin config

`admin/managed-config.toml` goes into the workspace settings in the Mistral
admin console. It overrides every user and project setting.

## Sources

- Mistral Vibe documentation: docs.mistral.ai (Vibe section)
- Mistral Vibe on PyPI: `mistral-vibe`

---

Powered by AI Bytes Lab™ · aibyteslab.com
