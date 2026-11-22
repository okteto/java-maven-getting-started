package com.okteto.helloworld;

import static org.hamcrest.Matchers.containsString;
import static org.hamcrest.Matchers.startsWith;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.forwardedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.webmvc.test.autoconfigure.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(RestHelloWorld.class)
class RestHelloWorldTest {

	@Autowired
	private MockMvc mvc;

	@Test
	void hello() throws Exception {
		mvc.perform(get("/api/info"))
			.andExpect(status().isOk())
			.andExpect(jsonPath("$.message").value(RestHelloWorld.MESSAGE))
			.andExpect(jsonPath("$.runtime").value(startsWith("Java ")));
	}

	@Test
	void page() throws Exception {
		// "/" forwards to the page, which Spring Boot serves from the static folder
		mvc.perform(get("/"))
			.andExpect(status().isOk())
			.andExpect(forwardedUrl("index.html"));
		mvc.perform(get("/index.html"))
			.andExpect(status().isOk())
			.andExpect(content().string(containsString("id=\"message\"")));
	}
}
