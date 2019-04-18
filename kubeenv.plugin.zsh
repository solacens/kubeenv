kubeenv () {
  # Making kubeenv separated config files
  BASE_DIR="$HOME/.kube/kubeenv"
  mkdir -p $BASE_DIR/

  # If its some builtin functions
  if [ "$1" = "list-configs" ]; then
    ls -1 $BASE_DIR/
    return
  fi
  if [ "$1" = "clean-configs" ]; then
    rm -r $BASE_DIR/
    echo 'Cleaned.'
    return
  fi

  for context in `kubectl config get-contexts --output='name'`; do
    normalized_context=$(echo $context | sed 's|/|-|g;s|:|-|g;s/|/-/g' )
    if [ ! -f $BASE_DIR/$normalized_context.yaml ]; then
      kubectl config view --context $context --minify --raw > $BASE_DIR/$normalized_context.yaml
      for namespace in `kubectl get namespace --output='name' | sed 's|namespace/||'`; do
        if [ "$namespace" != "default" ]; then
          cat $BASE_DIR/$normalized_context.yaml | yq w - 'contexts.0.context.namespace' "$namespace" > $BASE_DIR/$normalized_context\|$namespace.yaml
        fi
      done
    fi
  done
  # Show usages if no arguments
  if (( $# == 0 )); then
    echo 'Usage:'
    echo '  kubeenv list-configs'
    echo '  kubeenv clean-configs'
    echo '  kubeenv [context]'
    echo '  kubeenv [context] [namespace]'
    return 1
  fi

  if (( $# == 1 )); then
    # If context not found
    if [ ! -f $BASE_DIR/$1.yaml ]; then
      echo "Error: Context not found." >&2
      return 1
    fi
    # Create subshell
    KUBECONFIG="$BASE_DIR/$1.yaml" $SHELL
  else
    # If context not found
    if [ ! -f $BASE_DIR/$1\|$2.yaml ]; then
      echo "Error: Context with namespace not found." >&2
      return 1
    fi
    # Create subshell
    KUBECONFIG="$BASE_DIR/$1|$2.yaml" $SHELL
  fi
}

# Alias
alias kenv='kubeenv'

# Completion
_kubeenv () {
  _arguments "1: :($(kubectl config get-contexts --output='name' | sed 's|/|-|g;s|:|-|g;s/|/-/g'))"
}
compdef _kubeenv kubeenv kenv
