# kubeenv

> Kubernetes Environment for oh-my-zsh in subshell

### Installation

```sh
git clone https://github.com/plutux-labs/kubeenv ~/.oh-my-zsh/custom/plugins/kubeenv
```

Then enable it in plugins sections of your `.zshrc`

```sh
plugins=(… kubeenv)
```

### Usage

```sh
# kubeenv [context]
kubeenv minikube

# or just using completion 
kenv <tab><tab>
```

### Caveat

- If you setup your own `KUBECONFIG` environment in `~/.zshrc`, this plugin won't work.
