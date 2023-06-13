package org.springframework.samples.petclinic.integration;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.remote.RemoteWebDriver;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.net.MalformedURLException;
import java.net.URL;


@Configuration
public class ITConfig {
	
	final boolean useRemote = false;
	final boolean useHeadless = true;

    
    @Bean
    public WebDriver webDriver() throws MalformedURLException {
	    	if (useRemote) {
	        return new RemoteWebDriver(getRemoteUrl(), getDesiredCapabilities());
	    	} else if (useHeadless) {
	    		return new HtmlUnitDriver();
	    	} else {
	    		return new ChromeDriver();
	    	}
    }

    private DesiredCapabilities getDesiredCapabilities() {

        final DesiredCapabilities capabilities = DesiredCapabilities.chrome();

        return capabilities;
    }

    private URL getRemoteUrl() throws MalformedURLException {
    		//return new URL("http://localhost:4444/wd/hub");  // Selenium standalone server
    		return new URL("http://localhost:9515"); // Chrome driver
    }
}

