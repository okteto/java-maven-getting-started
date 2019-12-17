.PHONY: push
push:
	okteto build -t okteto/hello-world:java-maven .
