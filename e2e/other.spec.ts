import { test, expect } from '@playwright/test';

test.describe('other', () => {
    test('error page', async ({ page }) => {
      await page.goto('/oups');
      
      await expect(page.locator("text=Something happened...")).toHaveCount(1)
    })

    test('visit home page', async ({ page }) => {
      await page.goto('/');
      
      await expect(page.locator("text=Welcome")).toHaveCount(1)
    })
  });