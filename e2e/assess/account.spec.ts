import { test, expect } from '@playwright/test';

test.describe('owners', () => {
    test('find owner', async ({ page }) => {
      await page.goto('/owners/find');
      await page.locator('input[name="lastName"]').fill('davis');
  
      await page.locator('button:has-text("Find Owner")').click();
      await expect(page.locator("text=Betty Davis")).toHaveCount(1)
    })

    test('view owner', async ({ page }) => {
      await page.goto('/owners/2');
      await expect(page.locator("text=Betty Davis")).toHaveCount(1)
    })

    test('edit owner', async ({ page }) => {
      await page.goto('/owners/2');
      await page.locator('a:has-text("Edit Owner")').click();
      await page.locator('button:has-text("Update Owner")').click();
      await expect(page.locator("text=Betty Davis")).toHaveCount(1)
    })

    test('edit pet', async ({ page }) => {
      await page.goto('/owners/2/pets/2/edit');
      await page.locator('button:has-text("Update Pet")').click();
      await expect(page.locator("text=Betty Davis")).toHaveCount(1)
    })

    test('add pet', async ({ page }) => {
      await page.goto('/owners/2/pets/new');
      await page.locator('input[name="name"]').fill('Rover');
      await page.locator('input[name="birthDate"]').fill('2001-01-01');
      await page.locator('button:has-text("Add Pet")').click();
      await expect(page.locator("text=Rover")).toHaveCount(1)
    })

    test('add owner', async ({ page }) => {
      await page.goto('/owners/new');
      await page.locator('input[name="lastName"]').fill('Doe');
      await page.locator('input[name="firstName"]').fill('Jane');
      await page.locator('input[name="address"]').fill('1 Main Street');
      await page.locator('input[name="city"]').fill('Chicago');
      await page.locator('input[name="telephone"]').fill('555947343');
      await page.locator('button:has-text("Add Owner")').click();
      await expect(page.locator("text=Jane Doe")).toHaveCount(1)
    })

    test('add visit', async ({ page }) => {
      await page.goto('/owners/2/pets/2/visits/new');
      await page.locator('input[name="description"]').fill('Vaccination');
      await page.locator('button:has-text("Add Visit")').click();
      await expect(page.locator("text=Vaccination")).toHaveCount(1)
    })

  });