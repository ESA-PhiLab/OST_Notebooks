#! /bin/bash

# get ubuntu dependencies
apt-get -y install python3-pip git libgdal-dev python3-gdal libspatialindex-dev wget libgfortran5 imagemagick file

# set Snap and OTB version and download link
OTB_VERSION="8.1.1" # Update to the current version https://www.orfeo-toolbox.org/packages/
TBX_VERSION="8"
TBX_SUBVERSION="0"
SNAP_URL="http://step.esa.int/downloads/${TBX_VERSION}.${TBX_SUBVERSION}/installers"
TBX="esa-snap_sentinel_unix_${TBX_VERSION}_${TBX_SUBVERSION}.sh"

# get Snap
wget "${SNAP_URL}/${TBX}"
chmod 755 ${TBX}
wget https://raw.githubusercontent.com/ESA-PhiLab/OpenSarToolkit/master/snap.varfile

# install snap
./${TBX} -q -varfile snap.varfile
rm ${TBX}

# OTB installation
OTB=OTB-${OTB_VERSION}-Linux64.run
wget https://www.orfeo-toolbox.org/packages/${OTB}
chmod +x $OTB
./${OTB}
rm -f ${OTB}

# install ost
pip install git+https://github.com/ESA-PhiLab/OpenSarToolkit.git@main

# update snap
/home/ost/programs/snap/bin/snap --nosplash --nogui --modules --update-all 2>&1 | while read -r line; do \
  echo "$line" && \
  [ "$line" = "updates=0" ] && sleep 2 && pkill -TERM -f "snap/jre/bin/java"; \
done; exit 0


