package com.okteto.helloworld;

import java.net.InetAddress;
import java.net.UnknownHostException;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RestHelloWorld {

	// The message under the logo. Change it and save the file to see hot reload.
	static final String MESSAGE = "Built, deployed, and tested on Kubernetes.";

	// Info is what the page shows.
	record Info(String message, String runtime, String pod) {
	}

	// hello returns the message, the Java version, and the pod that answers.
	// Spring Boot serves the page, src/main/resources/static/index.html, at "/".
	@GetMapping("/api/info")
	public Info hello() throws UnknownHostException {
		String pod = InetAddress.getLocalHost().getHostName();
		return new Info(MESSAGE, "Java " + System.getProperty("java.version"), pod);
	}
}
