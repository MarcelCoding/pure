set --global FAILURE 1
set --universal __pure_git_prompt_cache "git"

function $__pure_git_prompt_cache --on-variable $__pure_git_prompt_cache
    commandline --function repaint
end

function _pure_prompt_first_line \
    --description 'Print contextual information before prompt.'

    command kill $_hydro_last_pid 2>/dev/null
    fish --private --command "
        set --universal __pure_git_prompt_cache (_pure_prompt_git)
    " &
    set --global _hydro_last_pid $last_pid

    set --local prompt_ssh (_pure_prompt_ssh)
    set --local prompt_container (_pure_prompt_container)
    set --local prompt_k8s (_pure_prompt_k8s)
    set --local prompt_git (_pure_prompt_git)
    set --local prompt_command_duration (_pure_prompt_command_duration)
    set --local prompt (_pure_print_prompt \
                            $prompt_ssh \
                            $prompt_container \
                            $prompt_k8s \
                            $prompt_git \
                            $prompt_command_duration
                        )
    set --local prompt_width (_pure_string_width $prompt)
    set --local current_folder (_pure_prompt_current_folder $prompt_width)

    set --local prompt_components
    if set --query pure_begin_prompt_with_current_directory; and test "$pure_begin_prompt_with_current_directory" = true
        set prompt_components \
            $current_folder \
            $__pure_git_prompt_cache \
            $prompt_ssh \
            $prompt_container \
            $prompt_k8s \
            $prompt_command_duration
    else
        set prompt_components \
            $prompt_ssh \
            $prompt_container \
            $prompt_k8s \
            $current_folder \
            $__pure_git_prompt_cache \
            $prompt_command_duration
    end

    echo (_pure_print_prompt $prompt_components)
end
