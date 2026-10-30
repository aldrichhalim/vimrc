# vimrc

One Vim config shared across every development environment the owner works in, kept in sync through this repo.

## Language

**Platform**:
One of the three environments the config must work on unchanged: macOS, Linux, or WSL. WSL counts as its own Platform, not as Linux.
_Avoid_: OS, environment

**Machine**:
One concrete computer (or WSL install) where the repo is cloned and the config is used.
_Avoid_: host, box

**Init**:
The one-time step that makes a fresh Machine ready: links the config into place and installs the plugin manager and plugins.
_Avoid_: setup, bootstrap, install

**Update**:
The recurring step that exchanges config changes between a Machine and the remote repo.
_Avoid_: sync, push, pull

**External dependency**:
A program the config needs that the plugin manager cannot provide, such as Node.js or ripgrep. Init reports missing ones; it does not install them.
_Avoid_: prerequisite, requirement
