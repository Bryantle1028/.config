source ~/.fish_aliases

set fish_cursor_visual underscore
set fish_cursor_default underscore
set fish_cursor_insert underscore

set -Ux LSCOLORS exfxcxdxbxegedabagacad

# Load API keys from private config file (not tracked in git)
if test -f ~/.config/fish/private.fish
    source ~/.config/fish/private.fish
end

function ls --description 'List contents of directory'
    set -lx LS_COLORS 'di=36:fi='
    command ls --color=auto -F $argv
end

fish_add_path /opt/homebrew/bin

# vi command line mode
fish_vi_key_bindings

# override control f
bind -M insert \cf accept-autosuggestion
bind -M visual \cf accept-autosuggestion
bind -M default \cf accept-autosuggestion

# Tell starship about vi mode changes
function fish_mode_prompt
    # Don't print anything - just let starship handle the display
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    alias cn='claude -w'       # new claude session with worktree
    alias cr='claude --resume'  # resume existing claude session
    alias x='codex'
    alias xn='cw'               # new codex session with worktree
    alias xr='codex resume --all'     # resume existing codex session across worktrees
    alias xrl='codex resume --all --last'

    function cw --description 'Create a git worktree and start Codex in it'
        set -l session_name
        if test (count $argv) -gt 0
            set session_name $argv[1]
            set -e argv[1]
        else
            set session_name codex-(date "+%Y%m%d-%H%M%S")
        end

        set -l root (git rev-parse --show-toplevel 2>/dev/null)
        if test $status -ne 0
            echo "cw: not in a git repository"
            return 1
        end

        set -l git_common_dir (git -C "$root" rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
        if test $status -ne 0
            return $status
        end

        set -l repo_root (dirname "$git_common_dir")
        set -l worktree_name (string replace -ra '[^A-Za-z0-9._-]+' '-' "$session_name")
        set -l worktree_parent "$repo_root/.codex/worktrees"
        set -l worktree "$worktree_parent/$worktree_name"

        if test -e "$worktree"
            echo "cw: $worktree already exists"
            return 1
        end

        mkdir -p "$worktree_parent"
        if test $status -ne 0
            return $status
        end

        set -l base_ref main
        if git -C "$root" remote get-url origin >/dev/null 2>&1
            echo "cw: fetching latest main from origin"
            git -C "$root" fetch origin +refs/heads/main:refs/remotes/origin/main
            if test $status -ne 0
                return $status
            end
            set base_ref origin/main
        else if not git -C "$root" show-ref --verify --quiet refs/heads/main
            echo "cw: main branch not found"
            return 1
        end

        git -C "$root" worktree add --detach "$worktree" "$base_ref"

        if test $status -ne 0
            return $status
        end

        codex --cd "$worktree" $argv
    end
end

starship init fish | source
