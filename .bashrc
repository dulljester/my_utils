umask 077
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
alias em="emacs -nw"
alias vm='vim'

unalias ls 2>/dev/null
alias c='cd a6; vim a6q4.c'
alias n='cd ..; vim marker-a6q4.txt'

prev () {
    # default to current directory if no previous
    local prevdir="./"
    local cwd=${PWD##*/}
    if [[ -z $cwd ]]; then
        # $PWD must be /
        echo 'No previous directory.' >&2
        return 1
    fi
    for x in ../*/; do
        if [[ ${x#../} == ${cwd}/ ]]; then
            # found cwd
            if [[ $prevdir == ./ ]]; then
                echo 'No previous directory.' >&2
                return 1
            fi
            cd "$prevdir"
            return
        fi
        if [[ -d $x ]]; then
            prevdir=$x
        fi
    done
    # Should never get here.
    echo 'Directory not changed.' >&2
    return 1
}

next () {
    local foundcwd=
    local cwd=${PWD##*/}
    if [[ -z $cwd ]]; then
        # $PWD must be /
        echo 'No next directory.' >&2
        return 1
    fi
    for x in ../*/; do
        if [[ -n $foundcwd ]]; then
            if [[ -d $x ]]; then
                cd "$x"
                return
            fi
        elif [[ ${x#../} == ${cwd}/ ]]; then
            foundcwd=1
        fi
    done
    echo 'No next directory.' >&2
    return 1
}

