Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbaKMRwT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:52:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59052 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933449AbaKMRwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:52:17 -0500
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: lee.jones@linaro.org, lgirdwood@gmail.com, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, linus.walleij@linaro.org, gnurou@gmail.com,
        broonie@kernel.org, tiwai@suse.de
Cc: perex@perex.cz, sameo@linux.intel.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        ckeepax@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        linux-gpio@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 4/6] gpio: arizona: Add support for WM8280/WM8281
Date: Thu, 13 Nov 2014 17:50:44 +0000
Message-Id: <1415901046-3391-5-git-send-email-rf@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com>
References: <1415901046-3391-1-git-send-email-rf@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
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

