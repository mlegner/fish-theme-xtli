function fish_prompt
  # Cache exit status
  set -l last_status $status

  # Just calculate these once, to save a few cycles when displaying the prompt
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end
  if not set -q __fish_prompt_char
    switch (id -u)
      case 0
        set -g __fish_prompt_char \u276f\u276f
      case '*'
        set -g __fish_prompt_char \$
    end
  end

  # Setup colors
  set -l normal (set_color normal)
  set -l cyan (set_color brcyan)
  set -l magenta (set_color magenta)
  set -l yellow (set_color -o bryellow)
  set -l bblack (set_color -o black)
  set -l bred (set_color -o red)
  set -l date (date "+%Y-%m-%d %H:%M")

  switch (id -u)
    case 0
      set __prompt_user_color -o magenta
      set __prompt_user \u221A
    case '*'
      set __prompt_user_color cyan
      set __prompt_user $USER
  end

  # Color prompt char red for non-zero exit status
  set -l pcolor $bblack
  if [ $last_status -ne 0 ]
    set pcolor $bred
  end

  # Configure __fish_git_prompt
  set -g __fish_git_prompt_show_informative_status true
  set -e __fish_git_prompt_showcolorhints

  # Top
  set fish_prompt_pwd_dir_length 0
  set -l prompt_columns (printf '%s%s %s: %s%s' $CONDA_PROMPT_MODIFIER $USER $date (prompt_pwd) (__fish_git_prompt) | wc -c)
  echo ""
  if test $prompt_columns -lt $COLUMNS
    echo -n (set_color $__prompt_user_color)$__prompt_user$normal $yellow$date$normal: $bred(prompt_pwd)$normal
    set -g __fish_git_prompt_showcolorhints true
    __fish_git_prompt
    echo
  else
    set fish_prompt_pwd_dir_length 1
    set -l prompt_columns (printf '%s%s %s: %s%s' $CONDA_PROMPT_MODIFIER $USER $date (prompt_pwd) (__fish_git_prompt) | wc -c)
    if test $prompt_columns -lt $COLUMNS
      echo -n (set_color $__prompt_user_color)$__prompt_user$normal $yellow$date$normal: $bred(prompt_pwd)$normal
      set -g __fish_git_prompt_showcolorhints true
      __fish_git_prompt
      echo
    else
      set -l prompt_columns (printf '%s%s%s' $CONDA_PROMPT_MODIFIER (prompt_pwd) (__fish_git_prompt) | wc -c)
      if test $prompt_columns -lt $COLUMNS
        echo -n $bred(prompt_pwd)$normal
        set -g __fish_git_prompt_showcolorhints true
        __fish_git_prompt
        echo
      end
    end
  end

  # Bottom
  echo -n $pcolor$__fish_prompt_char $normal
end
