
oc apply -f mysql-db.yaml
oc project test-database 
oc wait --for=condition=available deployment/model-registry-db --timeout=5m

oc project rhoai-model-registries
oc apply -f registry-rhoai.yaml
oc wait --for=condition=available modelregistry.modelregistry.opendatahub.io/modelregistry-public --timeout=5m

oc apply -f rhods-admins.yaml

# should not be needed if your are on a cluster with cert mgmt like with ROSA
# however, simply installing cert-manager in a non-ROSA cluster was insufficient to remove this need for this setting,
# where without it, the reconciliation between kubeflow and kserve inference services did not occur;
# need to investigate the actual creation of the cert-manager CRDS in our dev cluster, and then replicate those, to
# retry removing this setting
oc set env  deployment/odh-model-controller -n redhat-ods-applications MR_SKIP_TLS_VERIFY=true
sleep 60

oc get pods -n redhat-ods-applications
