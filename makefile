build:
	mvn clean install -Drelease=true -DargLine="-Djava.library.path=$(PWD)/target/native"
	ant clean jar

clean:
	mvn clean
	ant clean
