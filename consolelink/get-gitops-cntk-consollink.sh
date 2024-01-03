### Setting Argo UI URL and the secret will be echo-ed in your terminal
ARGOURL=$(oc get route -n openshift-gitops | grep openshift-gitops-cntk-server | awk '{print "https://"$2}')
ARGO_SECRET=$(oc get secret/openshift-gitops-cntk-cluster -n openshift-gitops -o json | jq -r '.data."admin.password"' | base64 -D)

( echo "cat <<EOF" ; cat argocd-consolelink.yaml_template;) | \
ARGOURL=${ARGOURL} \
sh > openshift-gitops-cntk.yaml
echo ${ARGOURL}
echo ${ARGO_SECRET}

### Setting Git Org console link required to set GIT_ORG
if [ -z ${GIT_ORG} ]; then echo "Please set GIT_ORG when running script, optional GIT_BASEURL and GIT_REPO to formed the git url GIT_BASEURL/GIT_ORG/*"; exit 1; fi

set -u
GIT_BASEURL=${GIT_BASEURL:-https://github.com}
( echo "cat <<EOF" ; cat git-org-consolelink.yaml_template;) | \
GIT_BASEURL=${GIT_BASEURL} \
sh > git-org-consolelink.yaml
echo ${GIT_BASEURL}/${GIT_ORG}

### CP4I Dashboard
#ACE
CP_CONSOLE_URL=$(oc get route -n ibm-common-services | grep cp-console | awk '{print "https://"$2}')
CPD_URL=$(oc get route -n tools | grep cpd | awk '{print "https://"$2}')
INTEGRATION_NAV_URL=$(oc get route -n tools | grep integration-navigator-pn | awk '{print "https://"$2}')


NAME="cp-console"
SECTION="ACE"
URL=${CP_CONSOLE_URL}
TEXT="CP Console"
( echo "cat <<EOF" ; cat consolelink.yaml_template;) | \
NAME=${NAME} SECTION=${SECTION} URL=${URL} TEXT=${TEXT} \
sh > cp-console-link.yaml

NAME="cpd-console"
SECTION="ACE"
URL=${CPD_URL}
TEXT="CPD Console"
( echo "cat <<EOF" ; cat consolelink.yaml_template;) | \
NAME=${NAME} SECTION=${SECTION} URL=${URL} TEXT=${TEXT} \
sh > cpd-console-link.yaml

NAME="integration-nav"
SECTION="ACE"
URL=${INTEGRATION_NAV_URL}
TEXT="Integration Navigator"
( echo "cat <<EOF" ; cat consolelink.yaml_template;) | \
NAME=${NAME} SECTION=${SECTION} URL=${URL} TEXT=${TEXT} \
sh > integration-nav-link.yaml

#APIC
APIC_CLOUD_URL=$(oc get route -n tools | grep admin | awk '{print "https://"$2}')
APIC_MANAGER_URL=$(oc get route -n tools | grep api-manager | awk '{print "https://"$2}')
APIC_PORTAL_URL=$(oc get route -n tools | grep portal-web | awk '{print "https://"$2}')


NAME="apic-cloud"
SECTION="APIC"
URL=${APIC_CLOUD_URL}
TEXT="APIC Cloud Manager"
( echo "cat <<EOF" ; cat consolelink.yaml_template;) | \
NAME=${NAME} SECTION=${SECTION} URL=${URL} TEXT=${TEXT} \
sh > apic-cloud-link.yaml

NAME="apic-api-manager"
SECTION="APIC"
URL=${APIC_MANAGER_URL}
TEXT="APIC API Manager"
( echo "cat <<EOF" ; cat consolelink.yaml_template;) | \
NAME=${NAME} SECTION=${SECTION} URL=${URL} TEXT=${TEXT} \
sh > apic-api-manager-link.yaml

NAME="apic-portal-manager"
SECTION="APIC"
URL=${APIC_PORTAL_URL}
TEXT="APIC Portal Manager"
( echo "cat <<EOF" ; cat consolelink.yaml_template;) | \
NAME=${NAME} SECTION=${SECTION} URL=${URL} TEXT=${TEXT} \
sh > apic-portal-manager-link.yaml