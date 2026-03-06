## Levantar el back

- Parados en '/src'
```bash
export JAVA_HOME="/c/Program Files/Java/jdk1.8.0_202"
export PATH="$JAVA_HOME/bin:$PATH"
```

- Luego compilar cada proyecto en el order que se muestra.
Estar posicionado en 'src/' y la terminal en modo _bash_

```bash
cd utils/
mvn clean install -DskipTests
cd ..

cd camunda-api-extension/
mvn clean install -DskipTests
cd ..

cd model/
mvn clean install -DskipTests
cd ..

cd nav-api-cli/
mvn clean install -DskipTests
cd ..
```

- En todos estos proyectos el build debe ser successful. Ahora el proyecto principal

```bash
cd slxapi/
mvn clean install -DskipTests
```

- Ahora levantar la app ( parado en slxapi/ )
```bash 
mvn spring-boot:run
```

