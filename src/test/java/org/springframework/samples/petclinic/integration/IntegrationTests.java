package org.springframework.samples.petclinic.integration;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Action;
import org.openqa.selenium.interactions.Actions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.context.embedded.LocalServerPort;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.SpringBootTest.WebEnvironment;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.samples.petclinic.PetClinicApplication;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import static org.hamcrest.Matchers.equalTo;
import static org.hamcrest.Matchers.is;

import java.util.List;

@RunWith(SpringRunner.class)
//@WebAppConfiguration
@SpringBootTest(webEnvironment=WebEnvironment.RANDOM_PORT, classes={PetClinicApplication.class})
@ContextConfiguration(classes = ITConfig.class)
public class IntegrationTests {

    @Autowired
    private WebDriver webDriver;

    //@org.springframework.boot.web.server.LocalServerPort
    @LocalServerPort
    private int serverPort;
    
    
    @Test
    public void searchForOwner() throws Exception {
    		final String url = String.format("http://localhost:%d/owners/find", serverPort);
    		
    		System.out.println("searchForOwner: " + url);
        this.webDriver.get(url);
        //Thread.sleep(1 * 1000);
        
        WebElement lastName = this.webDriver.findElement(By.name("lastName"));
        Assert.assertNotNull(lastName);
        
        Actions actions = new Actions(this.webDriver);
        
        actions.moveToElement(lastName);
        actions.click();
        actions.sendKeys("Davis");
        actions.perform();

        lastName.submit();

        // Wait for results to load.
        //Thread.sleep(1 * 1000);

        List<WebElement> owners = this.webDriver.findElements(By.cssSelector("a[href*='owners']"));
        Assert.assertNotNull(owners);
        Assert.assertThat(owners.size(), is(equalTo(3)));		// 2 results + 1 find
    }
}
