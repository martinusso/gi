# gi

Unified CLI wrapper around **Git** with plenty of time-saving shortcuts.

Instead of typing full `git` commands you can simply run:

```bash
gi <shortcut> [args...]
```

The wrapper expands the _shortcut_ to the full `git` command automatically.

## Installation

### Quick install (recommended)

Install **gi** in a single command using the bundled script:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/martinusso/gi/main/install.sh)"
```

or via `wget`:

```bash
sh -c "$(wget -qO- https://raw.githubusercontent.com/martinusso/gi/main/install.sh)"
```

### Manual install (from source)

```bash
git clone https://github.com/martinusso/gi.git
cd gi
cargo build --release
cp target/release/gi /usr/local/bin/
```

> **Note** `gi` requires only `git` to be installed (plus the Rust toolchain if you build from source).

## Updating

Already have **gi**? Upgrade to the latest version with:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/martinusso/gi/main/update.sh)"
```

or locally (if the repo is already cloned):

```bash
./update.sh
```

Under the hood the script simply runs:

```bash
cargo install --git https://github.com/martinusso/gi.git --locked --force
```

## Built-in Shortcuts

### Git shortcuts

| Shortcut           | Expands to                                 |
| ------------------ | ------------------------------------------ |
| `st`               | `git status`                               |
| `co`               | `git commit`                               |
| `br`               | `git branch`                               |
| `ch`               | `git checkout`                             |
| `chb &lt;name&gt;` | `git checkout -b &lt;name&gt;`             |
| `dif`              | `git difftool`                             |
| `lg`               | `git log --pretty=short`                   |
| `re`               | `git reset --hard HEAD`                    |
| `fp`               | `git fetch -p`                             |
| `ro`               | `git rebase origin/main`                   |
| `s`                | `git switch`                               |
| `ps`               | `git push origin <current-branch>`         |
| `psf`              | `git push origin <current-branch> --force` |
| `sp`               | `git stash pop`                            |
| `su`               | `git stash --include-untracked`            |

### Extra shortcuts (Graphite-inspired but executed with Git)

| Shortcut  | Expands to                                           |
| --------- | ---------------------------------------------------- |
| `ls`      | `git log --pretty=short`                             |
| `c`       | `git commit` _(flags like `-a`, `-m` remain intact)_ |
| `ss`      | `git push origin <current-branch>`                   |
| `m`       | `git commit --amend`                                 |
| `sync`    | `git pull --rebase`                                  |
| `rb`/`ro` | `git rebase origin/main`                             |

## Examples

```bash
# Git examples
$ gi st
$ gi chb feature/login
$ gi ps

$ gi ls
$ gi c -am "feat: new API"
$ gi ss
$ gi u       # up one level in the stack
```

Feel free to extend or modify the shortcuts in `src/main.rs` to match
your own workflow.
