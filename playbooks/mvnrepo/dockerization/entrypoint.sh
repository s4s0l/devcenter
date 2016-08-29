#!/bin/bash
if [ ! -e /sonatype-work/docker_bootstrapped ] && [ -d /nexus_bootstrap/ ]; then
    cp -fr /nexus_bootstrap/* /sonatype-work/
    touch /sonatype-work/docker_bootstrapped
fi


exec java \
  -Dnexus-work=${SONATYPE_WORK} -Dnexus-webapp-context-path=${CONTEXT_PATH} \
  -Xms${MIN_HEAP} -Xmx${MAX_HEAP} \
  -cp 'conf/:lib/*' \
  ${JAVA_OPTS} \
  org.sonatype.nexus.bootstrap.Launcher ${LAUNCHER_CONF}