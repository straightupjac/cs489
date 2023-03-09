FROM maven
WORKDIR /my_app
COPY . .
CMD ["mvn","-Drat.skip=true", "clean", "verify"]