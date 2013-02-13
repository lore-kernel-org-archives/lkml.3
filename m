Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3BMHCQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:02:16 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62497 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3BMHCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:02:13 -0500
From: Alexandre Courbot <gnurou@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3/4] gpiolib: move comment to right function
Date: Wed, 13 Feb 2013 16:03:01 +0900
Message-Id: <1360738983-22436-4-git-send-email-gnurou@gmail.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
References: <1360738983-22436-1-git-send-email-gnurou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexandre Courbot <acourbot@nvidia.com>

This comment applies to gpio_to_chip(), not gpiod_to_chip().

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index ad6df6b..d8aa1a0 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -172,12 +172,12 @@ static int gpio_ensure_requested(struct gpio_desc *desc)
 	return 0;
 }
 
-/* caller holds gpio_lock *OR* gpio is marked as requested */
 static struct gpio_chip *gpiod_to_chip(const struct gpio_desc *desc)
 {
 	return desc ? desc->chip : NULL;
 }
 
+/* caller holds gpio_lock *OR* gpio is marked as requested */
 struct gpio_chip *gpio_to_chip(unsigned gpio)
 {
 	return gpiod_to_chip(gpio_to_desc(gpio));
-- 
1.8.1.3

