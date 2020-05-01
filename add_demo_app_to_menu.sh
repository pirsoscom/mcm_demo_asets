
kubectl get navconfigurations.foundation.ibm.com multicluster-hub-nav -n kube-system -o yaml > navconfigurations.orginal
cp navconfigurations.orginal navconfigurations.ldap.yaml
nano navconfigurations.ldap.yaml

Add this (don't forget to change the URL)

  - id: id-ldap
    label: OpenLDAP Admin
    parentId: administer-mcm
    serviceId: webui-nav
    url: http://openldap-admin-default.cp4mcp-demo-001-a376efc1170b9b8ace6422196c51e491-0000.eu-de.containers.appdomain.cloud/




kubectl apply -n kube-system --validate=false -f navconfigurations.ldap.yaml  


http://grpc-web-route-grpcdemo-app.mcmapp001-a376efc1170b9b8ace6422196c51e491-0001.us-south.containers.appdomain.cloud/