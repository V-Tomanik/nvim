# Code station shell setup — sourced from ~/.zshrc by station/install.sh

export EDITOR=nvim
export VISUAL=nvim

# zoxide: `z thesis` jumps to the most-used folder matching "thesis"; `zi` picks interactively
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

alias v='nvim'
alias lg='lazygit'

# tm — one tmux session per project.
#   tm            session named after the current folder (create or attach)
#   tm thesis     jump (zoxide) to the folder matching "thesis", then the same
tm() {
  local dir="$PWD"
  if [ -n "$1" ]; then
    dir="$(zoxide query -- "$@")" || { echo "tm: no folder matches '$*'"; return 1; }
  fi
  local name
  name="$(basename "$dir" | tr '.:' '__')"
  if ! tmux has-session -t "=$name" 2>/dev/null; then
    tmux new-session -d -s "$name" -c "$dir"
  fi
  if [ -n "$TMUX" ]; then
    tmux switch-client -t "=$name"
  else
    tmux attach-session -t "=$name"
  fi
}
