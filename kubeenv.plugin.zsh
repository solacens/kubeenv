kubeenv () {
  # Making kubeenv separated config files
  mkdir -p $HOME/.kube/kubeenv/
  for context in `kubectl config get-contexts --output='name'`
  do
    normalized_context=$(echo $context | sed 's|/|-|' )
    if [ ! -f $HOME/.kube/kubeenv/$normalized_context.yaml ]; then
      kubectl config view --context $context --minify --raw > $HOME/.kube/kubeenv/$normalized_context.yaml
    fi
  done
  # Show usages if no arguments
  if (( $# == 0 ))
  then
    echo 'Usage: kubeenv [context]'
    return 1
  fi
  # If context not found
  if [ ! -f $HOME/.kube/kubeenv/$1.yaml ]; then
    echo "Error: Context not found." >&2
    return 1
  fi
  # Create subshell
  KUBECONFIG="$HOME/.kube/kubeenv/$1.yaml" $SHELL
}

# Alias
alias kenv='kubeenv'

# Completion
_kubeenv () {
  _arguments "1: :($(kubectl config get-contexts --output='name' | sed 's|/|-|'))"
}
compdef _kubeenv kubeenv kenv
