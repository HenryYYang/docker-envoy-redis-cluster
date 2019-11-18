FROM redis:5.0.4

# Install system dependencies for pumba
RUN apt-get update -qq && apt-get install --no-install-recommends -yqq iproute2