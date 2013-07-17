Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab3GQR1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:27:38 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56833 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab3GQR1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:27:33 -0400
From: Zubair Lutfullah <zubair.lutfullah@gmail.com>
To: jic23@cam.ac.uk
Cc: linux-iio@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, koen@dominion.thruhere.net,
        zubair.lutfullah@gmail.com
Subject: [PATCH 21/21] mfd: ti_am335x_tscadc.c fix checkpatch.pl issues
Date: Wed, 17 Jul 2013 18:26:50 +0100
Message-Id: <1374082010-28095-22-git-send-email-zubair.lutfullah@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
References: <1374082010-28095-1-git-send-email-zubair.lutfullah@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

code formatting corrected.
Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
---
 drivers/mfd/ti_am335x_tscadc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index e7314e4..b8d7dfb 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -278,8 +278,8 @@ static int tscadc_suspend(struct device *dev)
 	struct ti_tscadc_dev	*tscadc_dev = dev_get_drvdata(dev);
 
 	tscadc_writel(tscadc_dev, REG_SE, 0x00);
-        tscadc_dev->irqstat = tscadc_readl(tscadc_dev, REG_IRQENABLE);
-        tscadc_dev->ctrl = tscadc_readl(tscadc_dev, REG_CTRL);
+	tscadc_dev->irqstat = tscadc_readl(tscadc_dev, REG_IRQENABLE);
+	tscadc_dev->ctrl = tscadc_readl(tscadc_dev, REG_CTRL);
 	pm_runtime_put_sync(dev);
 
 	return 0;
@@ -297,7 +297,7 @@ static int tscadc_resume(struct device *dev)
 	if (tscadc_dev->tsc_cell != -1)
 		tscadc_idle_config(tscadc_dev);
 	am335x_tsc_se_update(tscadc_dev);
-        tscadc_writel(tscadc_dev, REG_CTRL, tscadc_dev->ctrl);
+	tscadc_writel(tscadc_dev, REG_CTRL, tscadc_dev->ctrl);
 
 	return 0;
 }
-- 
1.7.9.5

