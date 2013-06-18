Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab3FRJTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:19:21 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:33871 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755280Ab3FRJTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:19:17 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linus.walleij@linaro.org, sachin.kamat@linaro.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 1/4] pinctrl: bcm2835: Staticize bcm2835_gpio_pins
Date: Tue, 18 Jun 2013 14:34:24 +0530
Message-Id: <1371546267-22093-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'bcm2835_gpio_pins' is used only in this file.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/pinctrl/pinctrl-bcm2835.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-bcm2835.c b/drivers/pinctrl/pinctrl-bcm2835.c
index c8f20a3..a1c88b3 100644
--- a/drivers/pinctrl/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/pinctrl-bcm2835.c
@@ -113,7 +113,7 @@ static struct lock_class_key gpio_lock_class;
 
 /* pins are just named GPIO0..GPIO53 */
 #define BCM2835_GPIO_PIN(a) PINCTRL_PIN(a, "gpio" #a)
-struct pinctrl_pin_desc bcm2835_gpio_pins[] = {
+static struct pinctrl_pin_desc bcm2835_gpio_pins[] = {
 	BCM2835_GPIO_PIN(0),
 	BCM2835_GPIO_PIN(1),
 	BCM2835_GPIO_PIN(2),
-- 
1.7.9.5

