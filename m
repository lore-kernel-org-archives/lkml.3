Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624Ab3IKNNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:13:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37548 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813Ab3IKNNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:13:49 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: grant.likely@linaro.org, linus.walleij@linaro.org
Cc: patches@opensource.wolfsonmicro.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: [PATCH] gpio: arizona: Add wm8997 support to probe
Date: Wed, 11 Sep 2013 14:03:27 +0100
Message-Id: <1378904607-23349-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---

A bit of confusion with merging this last time because I
messed up the CCs, is safe to merge this patch on its own
now.

 drivers/gpio/gpio-arizona.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-arizona.c b/drivers/gpio/gpio-arizona.c
index fa8b6a7..a2bec3c 100644
--- a/drivers/gpio/gpio-arizona.c
+++ b/drivers/gpio/gpio-arizona.c
@@ -113,6 +113,7 @@ static int arizona_gpio_probe(struct platform_device *pdev)
 	switch (arizona->type) {
 	case WM5102:
 	case WM5110:
+	case WM8997:
 		arizona_gpio->gpio_chip.ngpio = 5;
 		break;
 	default:
-- 
1.7.2.5

