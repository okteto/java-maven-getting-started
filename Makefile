.PHONY: push
push:
	okteto build -t okteto/hello-world:java-maven-dev --target dev .
	okteto build -t okteto/hello-world:java-maven .
