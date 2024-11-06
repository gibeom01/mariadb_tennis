# Builder 단계
FROM alpine:latest AS builder

# OpenJDK 8, curl, tar 설치
RUN apk add --no-cache openjdk8 curl tar

# Tomcat 다운로드
RUN curl -f -O https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.tar.gz

# Tomcat 압축 해제
RUN mkdir -p /usr/local/tomcat && \
    tar -xzf apache-tomcat-9.0.89.tar.gz -C /usr/local/tomcat --strip-components=1

# MariaDB Java Client 다운로드 (최신 안정 버전으로 업데이트)
RUN curl -f -O https://downloads.mariadb.com/Connectors/java/connector-java-3.0.3/mariadb-java-client-3.0.3.jar

# JAR 파일 이동
RUN mv mariadb-java-client-3.0.3.jar /usr/local/tomcat/lib/ && \
    ls -l /usr/local/tomcat/lib/mariadb-java-client-3.0.3.jar  # JAR 파일 확인

# 파일 삭제
RUN rm -f apache-tomcat-9.0.89.tar.gz

# 불필요한 Tomcat 예제 파일들 제거
RUN rm -rf /usr/local/tomcat/webapps/examples /usr/local/tomcat/webapps/docs /usr/local/tomcat/webapps/manager /usr/local/tomcat/webapps/host-manager

# 필요한 권한 설정
RUN chmod +x /usr/local/tomcat/bin/*.sh

# 파일 복사 (빌드 컨텍스트 내 경로 사용)
COPY post /usr/local/tomcat/webapps/ROOT/

# Tomcat의 context.xml 파일을 MariaDB 연결 설정이 포함된 파일로 대체
COPY context.xml /usr/local/tomcat/conf/

# 최종 단계: 실제 컨테이너에 필요한 구성만 복사
FROM alpine:latest

RUN apk add --no-cache openjdk8-jre-base && \
    rm -rf /var/cache/apk/*

# JAVA_HOME 및 CATALINA_HOME 환경 변수 설정
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk/jre
ENV CATALINA_HOME=/usr/local/tomcat
ENV PATH="$JAVA_HOME/bin:$CATALINA_HOME/bin:$PATH"

# 빌더 단계에서 준비한 Tomcat과 필요한 파일을 복사
COPY --from=builder /usr/local/tomcat /usr/local/tomcat

# Tomcat 포트 노출
EXPOSE 8080

# Tomcat 서버 실행
CMD ["catalina.sh", "run"]

