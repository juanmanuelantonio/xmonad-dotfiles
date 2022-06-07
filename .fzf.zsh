# Setup fzf
# ---------
if [[ ! "$PATH" == */home/tungur/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/tungur/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/tungur/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/tungur/.fzf/shell/key-bindings.zsh"
