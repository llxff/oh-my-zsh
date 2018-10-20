# bookish-potato.zsh-theme
# Repo: https://github.com/llxff/oh-my-zsh
# Direct Link: https://github.com/llxff/oh-my-zsh/blob/master/themes/bookish-potato.zsh-theme
# Inspired by:
# https://github.com/robbyrussell/oh-my-zsh/blob/master/themes/af-magic.zsh-theme
# https://github.com/davydovanton/dotfiles/blob/master/battery


battery_info() {
  ioreg -n AppleSmartBattery -r | \
  grep -o '"[^"]*" = [^ ]*' | \
  sed -e 's/= //g' -e 's/"//g' | \
  sort
}

battery_external_connected() {
  battery_info | grep "ExternalConnected" | cut -f2 -d' '
}

battery_prompt_info() {
  BATTERY_STATUS="$(pmset -g batt | grep -o '[0-9]*%' | tr -d %)"

  if [[ ! $(battery_external_connected) = "No" ]]; then
    good_color=$FG[010]
    middle_color=$FG[010]
    warn_color=$FG[010]
  else
    good_color=$FG[136]
    middle_color=$FG[136]
    warn_color=$FG[196]
  fi

  if [[ $BATTERY_STATUS -ge 75 ]]; then
    COLOR=$good_color

  # Yellow
  elif [[ $BATTERY_STATUS -ge 25 ]] && [[ $BATTERY_STATUS -lt 75 ]]; then
    COLOR=$middle_color

  # Red
  elif [[ $BATTERY_STATUS -lt 25 ]]; then
    COLOR=$warn_color
  fi

  echo "$COLOR$BATTERY_STATUS％%{$reset_color%}"
}

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='$FG[235]------------------------------------------------------------%{$reset_color%}
$FG[020]$(basename `pwd`)\
$(git_prompt_info) \
$(battery_prompt_info)\
$FG[105]%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'
RPROMPT='$FG[235]$(date +"%b %d %H:%M")%{$reset_color%}%'

ZSH_THEME_GIT_PROMPT_PREFIX="$FG[206]:$FG[206]"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$FG[214]*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
