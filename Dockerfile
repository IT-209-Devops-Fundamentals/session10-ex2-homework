FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY . .
RUN echo "App ready"
ENV PORT=3000
EXPOSE 3000
CMD ["java", "-jar", "app.jar"]
