#!/usr/bin/bash
aws sts get-caller-identity | jq -r '.Arn'
if [[ ! -z "${EKS}" ]]; then
  aws eks --region ${AWS_REGION} update-kubeconfig --name ${ECOSYSTEM}-${ENVTYPE}-eks-cluster
else
  kubectl config set-context ${ECOSYSTEM}
fi

prompt_k8s(){
  k8s_current_context=$(kubectl config current-context 2> /dev/null)
  if [[ $? -eq 0 ]] ; then echo -e "(${k8s_current_context}) "; fi
}

PS1='$(prompt_k8s)# '
eval $(vn infra ecosystem ${ECOSYSTEM} --output=env)
eval $(op signin vn-infrastructure.1password.com)
# tsh login --proxy=teleport.${ECOSYSTEM}.vnops.net --bind-addr 0.0.0.0:${RANDOM_PORT}
