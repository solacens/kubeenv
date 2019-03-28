# kubeenv

> Kubernetes Environment for oh-my-zsh in subshell

### Installation

```sh
# yq is needed
brew install yq

# Get it installed
rm -rf ~/.oh-my-zsh/custom/plugins/kubeenv && git clone https://github.com/plutux-labs/kubeenv ~/.oh-my-zsh/custom/plugins/kubeenv
```

Then enable it in plugins sections of your `.zshrc`

```sh
plugins=(… kubeenv)
```

### Usage

```sh
# kubeenv [context]
kubeenv minikube

# kubeenv [context] [namespace]
kubeenv minikube some-namespace # But not default

# or just using completion 
kenv <tab><tab> # Namespace autocomplete is still not available
```

### Caveat

- If you setup your own `KUBECONFIG` environment in `~/.zshrc`, this plugin won't work.
