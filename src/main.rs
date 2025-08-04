use std::env;
use std::process::{Command, exit};

/// `gi` – unified CLI wrapper around Git.
/// See `README.md` for the complete list of shortcuts.
fn main() {
    let raw_args: Vec<String> = env::args().skip(1).collect();

    // No arguments → show `git --help`.
    if raw_args.is_empty() {
        exec("git", &["--help".into()]);
    }

    // Special compound command: `gi up [branch]`
    if matches!(raw_args[0].as_str(), "up" | "update") {
        run_up(&raw_args[1..]);
    }

    let expanded = expand_shortcuts(raw_args);
    exec("git", &expanded);
}

/// Spawn `program` with `args`, propagate the same exit status.
fn exec(program: &str, args: &[String]) -> ! {
    let status = Command::new(program)
        .args(args)
        .status()
        .expect("failed to execute command");

    exit(status.code().unwrap_or(1));
}

/// Compound command: switch to branch, fetch, and rebase.
fn run_up(args: &[String]) -> ! {
    let branch = args.get(0).map(String::as_str).unwrap_or("main");

    // git switch <branch>
    let st = Command::new("git")
        .args(["switch", branch])
        .status()
        .expect("failed to switch branch");
    if !st.success() {
        exit(st.code().unwrap_or(1));
    }

    // git fetch -p
    let st = Command::new("git")
        .args(["fetch", "-p"])
        .status()
        .expect("failed to fetch");
    if !st.success() {
        exit(st.code().unwrap_or(1));
    }

    // git rebase origin/<branch>
    let remote_branch = format!("origin/{}", branch);
    let st = Command::new("git")
        .args(["rebase", remote_branch.as_str()])
        .status()
        .expect("failed to rebase");

    exit(st.code().unwrap_or(1));
}

/// Return the current branch name (needed for `ps` / `psf`).
fn current_branch() -> String {
    /* returns branch name currently checked out */
    let output = Command::new("git")
        .args(["rev-parse", "--abbrev-ref", "HEAD"])
        .output()
        .expect("failed to obtain current branch");

    if !output.status.success() {
        exit(output.status.code().unwrap_or(1));
    }

    String::from_utf8_lossy(&output.stdout).trim().to_string()
}

/// Expands the first CLI argument (shortcut) into the corresponding list
/// of `git` arguments.
fn expand_shortcuts(mut args: Vec<String>) -> Vec<String> {
    let first = args.remove(0);

    match first.as_str() {
        // Explicit invocation `git` – return remaining arguments unchanged.
        "git" | "gi" => args,

        // Shortcuts
        "status" | "st" => prepend("status", args),
        "co" => prepend("commit", args),
        "br" => prepend("branch", args),
        "ch" => prepend("checkout", args),
        "dif" => prepend("difftool", args),
        "lg" | "ls" => {
            let mut v = vec!["log".into(), "--pretty=short".into()];
            v.extend(args);
            v
        }
        "reset" | "re" => {
            let mut v = vec!["reset".into(), "--hard".into(), "HEAD".into()];
            v.extend(args);
            v
        }
        "new" | "n" | "chb" => {
            let mut v = vec!["checkout".into(), "-b".into()];
            v.extend(args);
            v
        }
        "fp" => {
            let mut v = vec!["fetch".into(), "-p".into()];
            v.extend(args);
            v
        }
        "switch" | "s" => prepend("switch", args),
        "ps" | "psf" => {
            let branch = current_branch();
            let mut v = vec!["push".into(), "origin".into(), branch];
            if first == "psf" {
                v.push("--force".into());
            }
            v.extend(args);
            v
        }
        "sp" | "stashpop" => {
            let mut v = vec!["stash".into(), "pop".into()];
            v.extend(args);
            v
        }
        "su" | "stashu" => {
            let mut v = vec!["stash".into(), "--include-untracked".into()];
            v.extend(args);
            v
        }
        "commit" | "c" => prepend("commit", args),
        "modify" | "m" => {
            let mut v = vec!["commit".into(), "--amend".into()];
            v.extend(args);
            v
        }
        "sync" => {
            let mut v = vec!["pull".into(), "--rebase".into()];
            v.extend(args);
            v
        }
        "rebase" | "r" => {
            let mut v = vec!["rebase".into(), "-i".into(), "origin/main".into()];
            v.extend(args);
            v
        }
        "ro" | "rb" => {
            let mut v = vec!["rebase".into(), "origin/main".into()];
            v.extend(args);
            v
        }

        // Fallback: forward args unchanged (command + args).
        _ => {
            let mut v = vec![first];
            v.extend(args);
            v
        }
    }
}

/// Helper: push one item at the front of the vector and return it.
fn prepend<S: Into<String>>(head: S, mut tail: Vec<String>) -> Vec<String> {
    let mut v = vec![head.into()];
    v.append(&mut tail);
    v
}
