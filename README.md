# vimrc

A small, complete Vim setup for working alongside AI coding agents.

Agents write most of the code now. The editor's job is to let you read it, review it, and fix it quickly, on whatever machine you happen to be on. This config does that with ten well-known plugins and nothing clever: language-server features, fuzzy finding, git change markers, and files that reload the moment an agent touches them.

One file, one script, the same setup on macOS, Linux and WSL.

## Why this setup

- **Agent edits show up immediately.** Open files reload when changed on disk, whether you switch back to Vim or simply pause. For files under 10,000 lines the reload can be undone, so `u` reverts an agent's edit to a file you have open.
- **You can see what changed.** Git markers in the sign column show which lines were added, changed or removed since the last commit.
- **Reviewing is navigating.** Jump to definitions and references, read hover docs, and step through diagnostics, all from the language server.
- **Finding things is instant.** Fuzzy-find files, buffers and lines, and search the whole project with ripgrep.
- **Nothing to maintain.** No custom plugins, no plugin-specific DSLs, no framework. Every setting is plain Vim script you can read in one sitting.

## Quick start

```sh
git clone https://github.com/aldrichhalim/vimrc.git ~/vimrc
cd ~/vimrc
./sync.sh init
```

`init` does the whole setup and is safe to re-run:

1. Backs up an existing `~/.vimrc` to `~/.vimrc.bak.<timestamp>`, then symlinks `~/.vimrc` to this repo.
2. Checks for the programs the config needs and prints an install hint for any that are missing. It never installs system packages or uses `sudo`.
3. Downloads [vim-plug](https://github.com/junegunn/vim-plug) if needed and installs every plugin.

Language servers install in the background the first time you open Vim.

The symlink points at the clone, so keep the clone where it is. If you move it, run `./sync.sh init` again.

## Requirements

| Program | Why |
| --- | --- |
| Vim 9.0.0438 or newer | Required by coc.nvim |
| git, curl | Installing vim-plug and plugins |
| Node.js 16.18 or newer | Runs coc.nvim and its language servers |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Project-wide search (`:Rg`) |

Platform notes:

- **macOS:** `brew install vim node ripgrep`.
- **Linux:** install a Vim built with clipboard support (for example `vim-gtk3` on Debian and Ubuntu) to share the system clipboard. Distro packages of Vim and Node.js are often too old; use a PPA, Homebrew, or [nvm](https://github.com/nvm-sh/nvm) if so.
- **WSL:** yanks are copied to the Windows clipboard through `clip.exe`. Paste from Windows with your terminal's paste shortcut.

## Keeping machines in sync

```sh
./sync.sh update
```

Pulls changes from the remote, commits and pushes your local `vimrc` changes, and installs any plugins added on another machine. Only `vimrc` is committed automatically; commit changes to other files yourself.

Plugins removed from the config are not deleted automatically. Run `:PlugClean` to remove them.

## What's included

| Plugin | Purpose |
| --- | --- |
| [coc.nvim](https://github.com/neoclide/coc.nvim) | Completion, diagnostics, go-to-definition, rename, formatting |
| [fzf](https://github.com/junegunn/fzf) + [fzf.vim](https://github.com/junegunn/fzf.vim) | Fuzzy finding for files, buffers, lines and search results |
| [vim-gitgutter](https://github.com/airblade/vim-gitgutter) | Git change markers in the sign column |
| [vim-commentary](https://github.com/tpope/vim-commentary) | Toggle comments with `gc` |
| [auto-pairs](https://github.com/jiangmiao/auto-pairs) | Close brackets and quotes as you type |
| [vim-sensible](https://github.com/tpope/vim-sensible) | Defaults most people agree on |
| [vim-airline](https://github.com/vim-airline/vim-airline) | Status line and buffer tabs |
| [gruvbox](https://github.com/morhetz/gruvbox) | Color scheme (light, high contrast) |

Language servers come preconfigured for TypeScript/JavaScript, Python, C/C++, Go and JSON. Add more to `g:coc_global_extensions` in `vimrc`.

## Key mappings

The leader key is `,`.

### Code navigation

| Keys | Action |
| --- | --- |
| `gd` | Go to definition |
| `gy` | Go to type definition |
| `gi` | Go to implementation |
| `gr` | List references |
| `K` | Show documentation |
| `[g` / `]g` | Previous / next diagnostic |
| `,rn` | Rename symbol |
| `,a` | Code action (works on a visual selection too) |
| `,qf` | Apply quick fix |
| `,f` | Format file |

### Completion (insert mode)

| Keys | Action |
| --- | --- |
| `Tab` / `Shift-Tab` | Next / previous suggestion |
| `Enter` | Accept suggestion |
| `Ctrl-Space` | Open suggestions manually |

### Finding

| Keys | Action |
| --- | --- |
| `Ctrl-p` | Find files |
| `,b` | Switch buffer |
| `,g` | Search the project |
| `,G` | Search the project for the word under the cursor |
| `,/` | Search lines in the current file |
| `,:` | Command history |

### Git

| Keys | Action |
| --- | --- |
| `[c` / `]c` | Previous / next changed hunk |
| `,hp` | Preview hunk |
| `,hu` | Undo hunk |

### Editing and windows

| Keys | Action |
| --- | --- |
| `gcc` / `gc` | Toggle comment on line / selection |
| `J` / `K` (visual) | Move selected lines down / up |
| `Ctrl-s` | Save (normal, insert and visual mode) |
| `Esc` / `,Space` | Clear search highlight |
| `Ctrl-h/j/k/l` | Move between windows |
| `[b` / `]b` | Previous / next buffer |

## Defaults worth knowing

- Two-space indentation by default; four spaces for Python; tabs for Go and Makefiles.
- Undo history persists across sessions in `~/.vim/undo`.
- Files reopen at the line you left them.
- Pressing `Enter` or `o` on a commented line starts a plain line, not another comment.
- Folds are by syntax but start open.

## Repository layout

| Path | Purpose |
| --- | --- |
| `vimrc` | The configuration. `~/.vimrc` links here. |
| `sync.sh` | `init` and `update` commands |
| `CLAUDE.md`, `docs/agents/`, `GLOSSARY.md` | Context for AI coding agents working on this repo |
