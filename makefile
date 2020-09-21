build:
	mvn clean install -Drelease=true -DargLine="-Djava.library.path=$(PWD)/target/native"

clean:
	mvn clean
