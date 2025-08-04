# gi

Unified CLI wrapper around **Git** with plenty of time-saving shortcuts.

Instead of typing full `git` commands you can simply run:

```bash
gi <shortcut> [args...]
```

The wrapper expands the _shortcut_ to the full `git` command automatically.

---

## Installation

```bash
# Build the binary
cargo build --release

# Copy it somewhere on your $PATH
cp target/release/gi /usr/local/bin/
```

> **Note** `gi` requires only `git` to be installed. No external Graphite CLI is needed.

---

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

### Extra shortcuts (Graphite-inspired but executed with Git)

| Shortcut  | Expands to                                           |
| --------- | ---------------------------------------------------- |
| `ls`      | `git log --pretty=short`                             |
| `c`       | `git commit` _(flags like `-a`, `-m` remain intact)_ |
| `ss`      | `git push origin <current-branch>`                   |
| `m`       | `git commit --amend`                                 |
| `sync`    | `git pull --rebase`                                  |
| `rb`/`ro` | `git rebase origin/main`                             |

---

## Examples

```bash
# Git examples
$ gi st
$ gi chb feature/login
$ gi ps

# Graphite examples
$ gi ls
$ gi c -am "feat: new API"
$ gi ss
$ gi u       # up one level in the stack
```

Feel free to extend or modify the shortcuts in `src/main.rs` to match
your own workflow.

---

## License

MIT © 2024
