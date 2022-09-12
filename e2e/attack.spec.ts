import { test, expect } from '@playwright/test';

test.describe('attacks', () => {
    test('find owner', async ({ page }) => {
      await page.goto('/owners/find');
      await page.locator('input[name="lastName"]').fill('\' OR \'1\'=\'1');
  
      await page.locator('button:has-text("Find Owner")').click();
      await expect(page.locator("text=George Franklin")).toHaveCount(1)
    })

    test('edit owner', async ({ page }) => {
      page.on('dialog', async (dialog) => {
        expect(dialog.message()).toEqual('1')
        await dialog.accept()
      })

      await page.goto('/owners/2');
      await page.locator('a:has-text("Edit Owner")').click();
      await page.locator('input[name="address"]').fill('<script>alert(1)</script>');
      await page.locator('button:has-text("Update Owner")').click();
    })
  });