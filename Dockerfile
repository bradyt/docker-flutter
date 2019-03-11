FROM ubuntu

RUN apt-get update
RUN apt-get update && apt-get install -y \
        bash \
        curl \
        git \
        unzip \
        xz-utils
RUN apt-get update && apt-get install -y \
        libglu1-mesa

# Install flutter
ENV FLUTTER_HOME "/opt/flutter"
ENV FLUTTER_VERSION "1.2.1-stable"
RUN mkdir -p ${FLUTTER_HOME} && \
  curl -L https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v${FLUTTER_VERSION}.tar.xz -o /tmp/flutter.tar.xz --progress-bar && \
  tar xf /tmp/flutter.tar.xz -C /tmp && \
  mv /tmp/flutter/ -T ${FLUTTER_HOME} && \
  rm -rf /tmp/flutter.tar.xz

ENV PATH=$PATH:$FLUTTER_HOME/bin

RUN apt-get install -y \
        lib32stdc++6

RUN git clone -b androidx https://github.com/bradyt/flutter_wtf

ENV SDK_TOOLS "4333796"
ENV ANDROID_HOME "/opt/sdk"

# Download and extract Android Tools
RUN curl -L http://dl.google.com/android/repository/sdk-tools-linux-${SDK_TOOLS}.zip -o /tmp/tools.zip --progress-bar && \
  mkdir -p ${ANDROID_HOME} && \
  unzip /tmp/tools.zip -d ${ANDROID_HOME} && \
  rm -v /tmp/tools.zip

RUN apt-get update && apt-get install -y \
        openjdk-8-jdk-headless

ENV PATH ${PATH}:${ANDROID_SDK_HOME}/tools:${ANDROID_SDK_HOME}/platform-tools:/opt/tools

# Install SDK Packages
RUN mkdir -p /root/.android/ && touch /root/.android/repositories.cfg
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager "--licenses"
RUN ${ANDROID_HOME}/tools/bin/sdkmanager "--update"

RUN flutter config --no-analytics

ENV PATH=$PATH:$ANDROID_HOME/tools/bin
ENV BUILD_TOOLS="28.0.3"
ENV TARGET_SDK="28"

RUN ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;android-${TARGET_SDK}" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"

#   ${ANDROID_HOME}/tools/bin/sdkmanager "build-tools;${BUILD_TOOLS}" "platform-tools" "platforms;android-${TARGET_SDK}" "extras;android;m2repository" "extras;google;google_play_services" "extras;google;m2repository"

# RUN apt-get update && apt-get install -y \
#         emacs
#         && rm -rf /var/lib/apt/lists/*
