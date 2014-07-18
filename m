Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761633AbaGRMEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 08:04:23 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:60850 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761566AbaGRMEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 08:04:22 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, spk.linux@gmail.com,
        Cory Maccarrone <darkstar6262@gmail.com>
Subject: [PATCH 1/2 Resend] mfd: htc-i2cpld: Remove unused code
Date: Fri, 18 Jul 2014 17:30:16 +0530
Message-Id: <1405684817-20171-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed code unused in this function.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
Cc: Cory Maccarrone <darkstar6262@gmail.com>
---
Compile tested.
---
 drivers/mfd/htc-i2cpld.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/mfd/htc-i2cpld.c b/drivers/mfd/htc-i2cpld.c
index d7b2a75aca3e..b44f0203983b 100644
--- a/drivers/mfd/htc-i2cpld.c
+++ b/drivers/mfd/htc-i2cpld.c
@@ -332,18 +332,13 @@ static int htcpld_setup_chip_irq(
 		int chip_index)
 {
 	struct htcpld_data *htcpld;
-	struct device *dev = &pdev->dev;
-	struct htcpld_core_platform_data *pdata;
 	struct htcpld_chip *chip;
-	struct htcpld_chip_platform_data *plat_chip_data;
 	unsigned int irq, irq_end;
 	int ret = 0;
 
 	/* Get the platform and driver data */
-	pdata = dev_get_platdata(dev);
 	htcpld = platform_get_drvdata(pdev);
 	chip = &htcpld->chip[chip_index];
-	plat_chip_data = &pdata->chip[chip_index];
 
 	/* Setup irq handlers */
 	irq_end = chip->irq_start + chip->nirqs;
-- 
1.7.9.5

