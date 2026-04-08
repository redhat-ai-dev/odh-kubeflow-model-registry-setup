#!/bin/bash
oc apply -f ./cert-manager-operator.yaml
oc apply -f ./cert-manager-subscription.yaml
while true; do
	oc get csv -o name -n cert-manager-operator | grep cert > cert.txt
	if [ -s cert.txt ]; then
		export CERT=$(cat cert.txt)
		echo "cert csv is ${CERT}}"
		break
	else
		echo "cert.txt still emtpy"
		sleep 5
	fi
done
oc wait --for=jsonpath='{.status.phase}'=Succeeded "$CERT" -n cert-manager-operator --timeout=300s

oc apply -f ./jobset-operator.yaml
oc apply -f ./jobset-subscription.yaml
while true; do
	oc get csv -o name -n openshift-jobset-operator | grep jobset > jobset.txt
	if [ -s jobset.txt ]; then
		export JOBSET=$(cat jobset.txt)
		echo "jobset csv is ${JOBSET}}"
		break
	else
		echo "jobset.txt still emtpy"
		sleep 5
	fi
done
oc wait --for=jsonpath='{.status.phase}'=Succeeded "$JOBSET" -n openshift-jobset-operator --timeout=300s

oc apply -f ./job-set-cr.yaml

oc apply -f ./rhoai-subscription.yaml
while true; do
	oc get csv -o name -n redhat-ods-operator | grep rhods > hub.txt
	if [ -s hub.txt ]; then
		export RHODS=$(cat hub.txt)
		echo "hub csv is ${RHODS}"
		break
	else
		echo "hub.txt still empty"
		sleep 5
	fi
done
oc wait --for=jsonpath='{.status.phase}'=Succeeded "$RHODS" -n redhat-ods-operator --timeout=300s



