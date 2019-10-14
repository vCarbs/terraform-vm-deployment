#cloud-config
hostname: ${name}
fqdn: ${name}.vcarbs.com
manage_etc_hosts: true
runcmd:
  - [ sh, -xc, "echo $(mkdir -p /tmp/nutanix)" ]
  - echo "Nutanix cloud init test"
  - touch /tmp/nutanix/ntnxsuccess.txt