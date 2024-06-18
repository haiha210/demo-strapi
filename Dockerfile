FROM public.ecr.aws/docker/library/node:18-bookworm-slim
# Installing libvips-dev for sharp Compatibility
RUN apt-get update && apt-get install build-essential gcc autoconf automake zlib1g-dev libpng-dev nasm bash libvips-dev git \
 -y --no-install-recommends  && \
  rm -rf /var/lib/apt/lists/*
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

WORKDIR /opt/
COPY package.json yarn.lock ./
RUN yarn global add node-gyp
RUN yarn config set network-timeout 600000 -g && yarn install
ENV PATH /opt/node_modules/.bin:$PATH

WORKDIR /opt/app
COPY . .
RUN chown -R node:node /opt/app
USER node
RUN ["yarn", "build"]
EXPOSE 1337
CMD ["yarn", "develop"]
