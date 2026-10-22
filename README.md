# Mistral Vibe labs

Hands-on labs for **Mistral Vibe**, Mistral AI's coding agent for the terminal.
Each lab goes with an AI Bytes Lab video and contains the files shown on screen.
You can install them on your own machine, rerun every test from the video, and
adapt the config to your projects.

Vibe can read files, edit code and run shell commands for you. That makes it
useful, and it also means a default install can do more than you expect. For
example, it will print a `.env` file if you ask it to. These labs show what the
agent can reach, which settings change that, and how to check each change
instead of assuming it works.

## Labs

| Folder | Video | What you build | Tested with |
|---|---|---|---|
| [`part2-secure-setup/`](part2-secure-setup/) | Mistral Vibe Part 2: rules, permissions, trusted folders and admin config | A locked-down `~/.vibe` profile, a demo project with a fake `.env`, and an untrusted repo to test against | Mistral Vibe 3.0.1 |

Part 1 of the series (installing Vibe on a clean Linux system) has no companion
files. Each new video adds a folder here and a row to this table.

## What Part 2 covers

Part 2 protects your secrets in four layers, and each layer has a different job:

| Layer | Role | Where |
|---|---|---|
| `AGENTS.md` | **The request:** rules the model is asked to follow | `user/AGENTS.md` |
| `config.toml` | **The lock:** what Vibe actually lets each tool do | `user/config.toml` |
| Trusted folders | **The gate:** which projects may change your rules | trust dialog, `trusted_folders.toml` |
| Admin config | **Distribution:** team defaults from the Mistral admin console | `admin/managed-config.toml` |

On top of that, a small `pre_tool` hook refuses shell commands that name secret
files, as a last guard against accidents.

The video and the lab are clear about the limits:
- A rule in `AGENTS.md` is a request, not a control.
- `vibe --yolo` skips your own prompts and deny lists.
- Admin config is a way to hand out settings, not a security boundary.

The [Part 2 README](part2-secure-setup/README.md) lists every caveat we hit
while testing.

## Quick start

Requirements: Linux or macOS, bash, Python 3, and Mistral Vibe installed and
signed in. Run `vibe --setup` so the API key goes into the system keyring.

```bash
git clone https://github.com/aibyteslab/mistral-vibe-labs.git
cd mistral-vibe-labs/part2-secure-setup
./scripts/install.sh --lab    # installs the profile into ~/.vibe and creates ~/vibe-lab
./scripts/verify.sh           # checks file modes, config entries and key exposure
```

`install.sh` backs up any existing `config.toml`, `AGENTS.md` and `hooks.toml`
as `*.bak-<timestamp>` before writing, so you can roll back. `verify.sh` never
prints a key; it only reports whether one is exposed in your shell or profile.
Set `VIBE_HOME` to install into a different folder.

Then start `vibe` inside `~/vibe-lab` and repeat the tests from the video:
ask it to show the `.env` file, open the untrusted repo, and try `vibe --yolo`.

## Safety notes

- **Every secret in these labs is fake.** Never put a real API key in a lab file.
- Try the labs in a VM or a test user account first, not on a machine with
  client work or production credentials.
- Keep your key in the keyring (`vibe --setup`). Don't export
  `MISTRAL_API_KEY` in a shell profile.
- Use a separate, low-limit API key for experiments and revoke it when you're done.
- Vibe changes quickly. Each lab states the version it was tested with; on a
  newer version, rerun the tests before you rely on the config.

## Feedback

Found a setting that behaves differently on your version, or a gap in the
config? Open an issue and include your Vibe version and what
you expected to happen.

## License

[MIT](LICENSE). Use, copy and adapt the config freely.

Mistral AI and Mistral Vibe are trademarks of Mistral AI. This project is
independent and not affiliated with or endorsed by Mistral AI.

---

Powered by AI Bytes Lab™ · [aibyteslab.com](https://aibyteslab.com)
