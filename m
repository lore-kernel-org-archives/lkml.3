Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbaJ0WKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 18:10:33 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:49218 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaJ0WKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 18:10:30 -0400
From: Matthias Klein <matthias.klein@linux.com>
To: linux-rpi-kernel@lists.infradead.org, swarren@wwwdotorg.org,
        linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2] pinctrl: bcm2835: Start GPIO numeration at zero
Date: Mon, 27 Oct 2014 23:09:59 +0100
Message-Id: <1414447799-1284-1-git-send-email-matthias.klein@linux.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Numerate the GPIOs from 0..53 instead of 202..255.

Signed-off-by: Matthias Klein <matthias.klein@linux.com>
---
Changes in v2:
 - fix wrong gpio range 0..54 in comment
---
 drivers/pinctrl/pinctrl-bcm2835.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
index 5bcfd7a..c183d0f 100644
--- a/drivers/pinctrl/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/pinctrl-bcm2835.c
@@ -382,7 +382,7 @@ static struct gpio_chip bcm2835_gpio_chip = {
 	.get = bcm2835_gpio_get,
 	.set = bcm2835_gpio_set,
 	.to_irq = bcm2835_gpio_to_irq,
-	.base = -1,
+	.base = 0,
 	.ngpio = BCM2835_NUM_GPIOS,
 	.can_sleep = false,
 };
-- 
2.1.2

