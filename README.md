# kubeenv

> Kubernetes Environment for oh-my-zsh in subshell

### Installation

```sh
# yq is needed
brew install yq

# Get it installed or updated
rm -rf ~/.oh-my-zsh/custom/plugins/kubeenv && rm -rf ~/.kube/kubeenv && git clone https://github.com/solacens/kubeenv ~/.oh-my-zsh/custom/plugins/kubeenv
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

kubeenv list-configs # To list generated seperated configs

kubeenv clean-configs # To clean generated seperated configs incase you changed something in your default KUBECONFIG

# or just using completion 
kenv <tab><tab> # Namespace autocomplete is still not available
```

### Caveat

- If the tool stucks, it's probably that some of your cluster cannot be connected.

- If you setup your own `KUBECONFIG` environment in `~/.zshrc`, this plugin won't work.
