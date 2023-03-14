#!/bin/bash -x

tar -xvzf /non-free/cryptoserver-driver-v${DRIVER_VERSION}-linux.tgz
pushd linux-drv
make KERNELDIR=/usr/src/kernels/${KERNEL_VERSION}.x86_64 EXTRA_CFLAGS=-DPDE_DATA=pde_data

cat > /var/tmp/postinstall.sh <<_EOF
#!/bin/bash
ls /lib/modules/${KERNEL_VERSION}.x86_64/extra/cryptoserver.* | weak-modules --add-modules
udevadm trigger
_EOF
cp /nfpm.yaml .
sed -i'' -e "s,%KERNEL_VERSION%,${KERNEL_VERSION},g" nfpm.yaml
sed -i'' -e "s,%DRIVER_VERSION%,${DRIVER_VERSION},g" nfpm.yaml
sed -i'' -e "s,%DRIVER_RELEASE%,${DRIVER_RELEASE},g" nfpm.yaml
nfpm package -f nfpm.yaml --packager rpm --target /outputs/

#exec bash
