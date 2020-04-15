
#IMAGE: Get the base image for Liberty
FROM ibmcom/websphere-liberty:webProfile7-ubi-min-amd64

#BINARIES: Add in all necessary application binaries
COPY ./server.xml /config
COPY ./target/modresorts1.0.war /config/apps/


#FEATURES: Install any features that are required
USER root
USER root
RUN configure.sh
USER 1001


# Upgrade to production license if URL to JAR provided
ARG LICENSE_JAR_URL
RUN \
   if [ $LICENSE_JAR_URL ]; then \
     wget $LICENSE_JAR_URL -O /tmp/license.jar \
     && java -jar /tmp/license.jar -acceptLicense /opt/ibm \
     && rm /tmp/license.jar; \
   fi


