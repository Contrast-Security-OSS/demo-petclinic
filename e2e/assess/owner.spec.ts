import { test, expect } from '@playwright/test';

test.describe('vets', () => {
    test('view as html', async ({ page }) => {
      await page.goto('/vets.html');

      await expect(page.locator("text=James Carter")).toHaveCount(1)
    })

    test('view as xml', async ({ page }) => {
      await page.goto('/vets.xml');
      await expect(page).toHaveURL(/.*vets.xml/);
    })

    test('view as json', async ({ page }) => {
      await page.goto('/vets.json');
      await expect(page).toHaveURL(/.*vets.json/);
    })


  });