Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbbAQP1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 10:27:40 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42046 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbbAQP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 10:26:10 -0500
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org
Cc: broonie@kernel.org, cw00.choi@samsung.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, rf@opensource.wolfsonmicro.com
Subject: [RESEND PATCH 4/6] gpio: arizona: Add support for WM8280/WM8281
Date: Sat, 17 Jan 2015 15:21:25 +0000
Message-Id: <1421508087-22311-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1421508087-22311-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
References: <1421508087-22311-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
---
 drivers/gpio/gpio-arizona.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpio/gpio-arizona.c b/drivers/gpio/gpio-arizona.c
index fe369f5..9665d0a 100644
--- a/drivers/gpio/gpio-arizona.c
+++ b/drivers/gpio/gpio-arizona.c
@@ -116,6 +116,7 @@ static int arizona_gpio_probe(struct platform_device *pdev)
 	switch (arizona->type) {
 	case WM5102:
 	case WM5110:
+	case WM8280:
 	case WM8997:
 		arizona_gpio->gpio_chip.ngpio = 5;
 		break;
-- 
1.7.2.5

