# Environement to compile my java code
FROM gradle:8.7-jdk21 AS compiler

# Source Directory of the container
WORKDIR /app

# Copy my code into /app
COPY . .

# Build the project
RUN ./gradlew bootWar

# Environnement to start the project from the WAR
FROM eclipse-temurin:21-jre-alpine-3.23 AS runner
RUN mkdir /opt/app

# Copy the WAR from the compiler STAGE
COPY --from=compiler /app/build/libs/*.war /opt/app/app.war

# Execute app.war
CMD ["java", "-jar", "/opt/app/app.war"]