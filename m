Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab3BOFrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 00:47:21 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1316 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935382Ab3BOFqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 00:46:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Feb 2013 21:42:31 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>, Ryan Mallon <rmallon@gmail.com>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3/4] gpiolib: move comment to right function
Date: Fri, 15 Feb 2013 14:46:16 +0900
Message-ID: <1360907177-6468-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
References: <1360907177-6468-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comment applies to gpio_to_chip(), not gpiod_to_chip().

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpio/gpiolib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index a33bfc2..c2534d6 100644
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

