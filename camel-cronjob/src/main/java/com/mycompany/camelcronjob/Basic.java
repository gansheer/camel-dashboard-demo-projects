package com.mycompany.camelcronjob;

import org.apache.camel.builder.RouteBuilder;

public class Basic extends RouteBuilder {

    @Override
    public void configure() throws Exception {
        from("timer:java?delay=0&period=1&repeatCount=1")
            .setBody()
                .simple("Hello Camel from ${routeId}")
            .log("${body}");
    }
}
