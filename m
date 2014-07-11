Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbaGKMaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:30:30 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50836 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbaGKMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:30:27 -0400
From: Sachin Kamat <sachin.kamat@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, spk.linux@gmail.com, darkstar6262@gmail.com
Subject: [PATCH 1/1] mfd: htc-i2cpld: Remove unused code
Date: Fri, 11 Jul 2014 17:56:37 +0530
Message-Id: <1405081597-24889-1-git-send-email-sachin.kamat@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed code unused in this function.

Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
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

