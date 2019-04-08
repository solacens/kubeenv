kubeenv () {
  # Making kubeenv separated config files
  mkdir -p $HOME/.kube/kubeenv/
  for context in `kubectl config get-contexts --output='name'`; do
    normalized_context=$(echo $context | sed 's|/|-|g;s|:|-|g;s/|/-/g' )
    if [ ! -f $HOME/.kube/kubeenv/$normalized_context.yaml ]; then
      kubectl config view --context $context --minify --raw > $HOME/.kube/kubeenv/$normalized_context.yaml
      for namespace in `kubectl get namespace --output='name' | sed 's|namespace/||'`; do
        if [ "$namespace" != "default" ]; then
          cat $HOME/.kube/kubeenv/$normalized_context.yaml | yq w - 'contexts.0.context.namespace' "$namespace" > $HOME/.kube/kubeenv/$normalized_context\|$namespace.yaml
        fi
      done
    fi
  done
  # Show usages if no arguments
  if (( $# == 0 )); then
    echo 'Usage: kubeenv [context]'
    return 1
  fi

  if (( $# == 1 )); then
    # If context not found
    if [ ! -f $HOME/.kube/kubeenv/$1.yaml ]; then
      echo "Error: Context not found." >&2
      return 1
    fi
    # Create subshell
    KUBECONFIG="$HOME/.kube/kubeenv/$1.yaml" $SHELL
  else
    # If context not found
    if [ ! -f $HOME/.kube/kubeenv/$1\|$2.yaml ]; then
      echo "Error: Context with namespace not found." >&2
      return 1
    fi
    # Create subshell
    KUBECONFIG="$HOME/.kube/kubeenv/$1|$2.yaml" $SHELL
  fi
}

# Alias
alias kenv='kubeenv'

# Completion
_kubeenv () {
  _arguments "1: :($(kubectl config get-contexts --output='name' | sed 's|/|-|g;s|:|-|g;s/|/-/g'))"
}
compdef _kubeenv kubeenv kenv
