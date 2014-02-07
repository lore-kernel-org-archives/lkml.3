Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaBGEng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 23:43:36 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:25134 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaBGEne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 23:43:34 -0500
X-AuditID: cbfee690-b7f266d00000287c-32-52f464753544
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        naveenkrishna.ch@gmail.com, kgene.kim@samsung.com, wsa@the-dreams.de,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 v4] i2c: exynos5: configure fifo_depth based on HSI2C
 module variant
Date: Fri, 07 Feb 2014 10:13:15 +0530
Message-id: <1391748195-12490-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
References: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkVrc05UuQwerVsha9C66yWWx6fI3V
	ouPvF0aLy7vmsFnMOL+PyWLRtv/MFitPzGJ2YPfYOesuu8fmJfUefVtWMXqcPPWExePzJrkA
	1igum5TUnMyy1CJ9uwSujC0zLzMWvBGr+NSymrmB8YtQFyMnh4SAiUTHxdmsELaYxIV769m6
	GLk4hASWMkp8eX+OHaboyMPFzCC2kMAiRolTF5MgivqZJLa8uQpWxCZgJnFw0WowW0RAVqL1
	wRqwBmaBzYwSm1stQWxhgSiJlrfrGEFsFgFVieu/DrGB2LwCrhJP3+4HuoIDaJmCxJxJNiBh
	TgE3iX9PJjKBhIWASq5PjIQ4Zx67xNe9hRBTBCS+TT7EAtEpK7HpADNEiaTEwRU3WCYwCi9g
	ZFjFKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERjep/89m7CD8d4B60OMyUDjJjJLiSbnA+Mj
	ryTe0NjMyMLUxNTYyNzSjDRhJXFetUdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYc07a
	afnw1RzpEN/ntWJ5XNmNzdHM+TmL/fMD37Vtnnr9sqjhVqO3B+V4uILKtm6/caE52DAnf3LP
	lX6v+1p/Jzyf1pt4yD7X2IXr7NTH+3///Wd5l4td++TdQ2Jpjy8uvRD3bC87mx2vaceG+Fez
	/Hb+f1s0a4twr8jh/0mWX7ge+N/+wcxzQ4mlOCPRUIu5qDgRAMyBnLWFAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAd3SlC9BBo9PiFr0LrjKZrHp8TVW
	i46/XxgtLu+aw2Yx4/w+JotF2/4zW6w8MYvZgd1j56y77B6bl9R79G1Zxehx8tQTFo/Pm+QC
	WKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZsmXmZseCNWMWnltXMDYxf
	hLoYOTkkBEwkjjxczAxhi0lcuLeeDcQWEljEKHHqYlIXIxeQ3c8kseXNVXaQBJuAmcTBRavB
	bBEBWYnWB2vAmpkFNjNKbG61BLGFBaIkWt6uYwSxWQRUJa7/OgQ2lFfAVeLp2/2sXYwcQMsU
	JOZMsgEJcwq4Sfx7MpEJJCwEVHJ9YuQERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3
	MYLj55nUDsaVDRaHGAU4GJV4eE8s/RwkxJpYVlyZe4hRgoNZSYSXO+FLkBBvSmJlVWpRfnxR
	aU5q8SHGZKCbJjJLiSbnA2M7ryTe0NjE3NTY1NLEwsTMkjRhJXHeA63WgUIC6YklqdmpqQWp
	RTBbmDg4pRoYNWfwKGzU2Bej+T/+YsdUu5LmTQ3HjsQtWR6u9jyKe5LKv0IjqXXKt4XiuG9x
	eilZ7XplWHJIKuvNrTONnSaPvxiyBiQ4nl73OrS4+aCzyvfe9xZdS6+fcz3toVLdHJToV/h4
	fqLHWmHubStaV35yDfDs/nQ/+9zDGjeXusQpOxSlKopk5OOUWIozEg21mIuKEwEhh8Kf4wIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fifo_depth of the HSI2C is not constant
Exynos5420 and Exynos5250 supports fifo_depth of 64bytes
Exynos5260 supports fifo_depth of 16bytes.

This patch configures the fifo_depth based on HSI2C modules version.

Signed-off-by: Naveen Krishna Chatradhi <ich.naveen@samsung.com>
[For finding out the difference and initial contribution]
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
changes since v3:
use variant struct to handle the fifo depths

 drivers/i2c/busses/i2c-exynos5.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 12730d1..5c875c0 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -76,12 +76,6 @@
 #define HSI2C_RXFIFO_TRIGGER_LEVEL(x)		((x) << 4)
 #define HSI2C_TXFIFO_TRIGGER_LEVEL(x)		((x) << 16)
 
-/* As per user manual FIFO max depth is 64bytes */
-#define HSI2C_FIFO_MAX				0x40
-/* default trigger levels for Tx and Rx FIFOs */
-#define HSI2C_DEF_TXFIFO_LVL			(HSI2C_FIFO_MAX - 0x30)
-#define HSI2C_DEF_RXFIFO_LVL			(HSI2C_FIFO_MAX - 0x10)
-
 /* I2C_TRAILING_CTL Register bits */
 #define HSI2C_TRAILING_COUNT			(0xf)
 
@@ -455,7 +449,7 @@ static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
 		fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
 		fifo_level = HSI2C_TX_FIFO_LVL(fifo_status);
 
-		len = HSI2C_FIFO_MAX - fifo_level;
+		len = i2c->variant->fifo_depth - fifo_level;
 		if (len > (i2c->msg->len - i2c->msg_ptr))
 			len = i2c->msg->len - i2c->msg_ptr;
 
@@ -523,6 +517,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 	u32 i2c_auto_conf = 0;
 	u32 fifo_ctl;
 	unsigned long flags;
+	unsigned short trig_lvl;
 
 	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
 	i2c_ctl &= ~(HSI2C_TXCHON | HSI2C_RXCHON);
@@ -533,13 +528,19 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 
 		i2c_auto_conf = HSI2C_READ_WRITE;
 
-		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(HSI2C_DEF_TXFIFO_LVL);
+		trig_lvl = (i2c->msg->len > i2c->variant->fifo_depth) ?
+			(i2c->variant->fifo_depth * 3/4) : i2c->msg->len;
+		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(trig_lvl);
+
 		int_en |= (HSI2C_INT_RX_ALMOSTFULL_EN |
 			HSI2C_INT_TRAILING_EN);
 	} else {
 		i2c_ctl |= HSI2C_TXCHON;
 
-		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(HSI2C_DEF_RXFIFO_LVL);
+		trig_lvl = (i2c->msg->len > i2c->variant->fifo_depth) ?
+			(i2c->variant->fifo_depth * 1/4) : i2c->msg->len;
+		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(trig_lvl);
+
 		int_en |= HSI2C_INT_TX_ALMOSTEMPTY_EN;
 	}
 
@@ -731,6 +732,8 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
+	i2c->variant = exynos5_i2c_get_variant(pdev);
+
 	exynos5_i2c_reset(i2c);
 
 	ret = i2c_add_adapter(&i2c->adap);
-- 
1.7.9.5

