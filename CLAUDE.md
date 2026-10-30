# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A one-file dotfiles repo for Vim. `vimrc` is the real file; `~/.vimrc` is a symlink to it, so editing either edits the same file.

## Commands

- `./sync.sh init` — first-time setup on a machine: moves an existing `~/.vimrc` into the repo (if the repo has none), otherwise backs it up to `~/.vimrc.bak.<timestamp>`, then symlinks `~/.vimrc` -> `vimrc`. Safe to re-run.
- `./sync.sh update` — `git pull --rebase`, commits `vimrc` if changed, pushes, then re-checks the symlink.
- Check the config loads cleanly: `vim -es -u vimrc -c 'qa!'` (plugins must be installed for no errors).

## vimrc structure

- Plugins are managed by vim-plug (`plug#begin`/`plug#end`); install with `:PlugInstall`. vim-plug itself is not bootstrapped by the file.
- `mapleader` is `,` and is set before plugins so all `<leader>` mappings see it.
- coc.nvim provides LSP/completion; language servers come from `g:coc_global_extensions`. `<CR>` is owned by coc, so auto-pairs' `<CR>` mapping is disabled (`g:AutoPairsMapCR = 0`) — keep that in mind when changing either.
- `autoread` plus the `vimrc_autoread` checktime autocmd reload files changed externally (e.g. by AI coding tools).
- Autocommands live in named `augroup`s with `autocmd!`, so the file can be re-sourced without duplicating them; follow that pattern.

## Agent skills

### Issue tracker

Issues are tracked in GitHub Issues on aldrichhalim/vimrc via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Default labels: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `GLOSSARY.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
