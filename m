Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab3KVGMy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 01:12:54 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14282 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3KVGMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 01:12:50 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-d2-528ef5e1fe89
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, hs@denx.de
Cc: khali@linux-fr.org, ben-linux@fluff.org, naveenkrishna.ch@gmail.com
Subject: [PATCH 2/2] i2c: exynos5: configure fifo_depth based on HSI2C module
 version
Date: Fri, 22 Nov 2013 11:44:11 +0530
Message-id: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.10.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkWvfh174ggzlXxSwmrTvAZLHjzn1m
	i8a/kRYdf78wWlzeNYfNYsb5fUwWi7b9Z3Zg95g36wSLx99VL5g9ds66y+5xpeEkm8fnTXIB
	rFFcNimpOZllqUX6dglcGa+/5hRsk6i4//gKWwPjZ+EuRg4OCQETienfg7sYOYFMMYkL99az
	dTFycQgJLGWU+Nl5nREiYSLR/2s2C0RiOqPEy93H2CGcHiaJ3X0rmUCq2ATMJA4uWs0OYosI
	5Ei8Or2KFcRmFnCXWHKtlRVkm7BAuMTFL7IgYRYBVYlTr14ClbNz8Aq4Srx1h1ilKNH9bALY
	DRIC/9kk7rTPZ4UoF5D4NvkQC8TNshKbDjBD1EtKHFxxg2UCo+ACRoZVjKKpBckFxUnpRSZ6
	xYm5xaV56XrJ+bmbGIHBevrfswk7GO8dsD7EmAw0biKzlGhyPjDY80riDY3NjCxMTUyNjcwt
	zUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsX5Xx8rGr2GhKwS8HiRFBTR1
	T80TaDT9k/DmW4RRwJopvEeue77ay1u7zOXLi8ILz73zTutUZAtF+esz3fVzn3j1sPMEgdVr
	Bb6Lchny/Tp88Epq27UD8iqzWWt/JZZqN933Taq53Vqt+GLfs+3HDmv8bPs6+XK4i/DTgp1l
	zw4bmFpMnJ7TrcRSnJFoqMVcVJwIAAWzfSVsAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jQd2HX/uCDI5O5rWYtO4Ak8WOO/eZ
	LRr/Rlp0/P3CaHF51xw2ixnn9zFZLNr2n9mB3WPerBMsHn9XvWD22DnrLrvHlYaTbB6fN8kF
	sEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2h
	pFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcx4/TWnYJtExf3HV9gaGD8L
	dzFyckgImEj0/5rNAmGLSVy4t56ti5GLQ0hgOqPEy93H2CGcHiaJ3X0rmUCq2ATMJA4uWs0O
	YosI5Ei8Or2KFcRmFnCXWHKtFcjm4BAWCJe4+EUWJMwioCpx6tVLoHJ2Dl4BV4m37hCrFCW6
	n01gm8DIvYCRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcDQ8k9rBuLLB4hCjAAejEg+v
	gE1fkBBrYllxZe4hRgkOZiUR3l9XgUK8KYmVValF+fFFpTmpxYcYk4F2T2SWEk3OB0ZqXkm8
	obGJuamxqaWJhYmZJWnCSuK8B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwTni2omg2H98XnaLF
	QitebjTvLNt02kD+bKK5z7TWhJfXG2ff3r2OexJv4XxXX474Q/ELI1WnV0nlW/bXPetoerF6
	Tp3v2nrjFb2XpSedvrr0tMprja3PTu/7t5TdUE9ba7tN9s5L+4WM6pxfc2Yz3pAR4Wk6Z/l6
	tbSj73kFsbWfDhzZdPBMrBJLcUaioRZzUXEiANFvWCfKAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fifo_depth of the HSI2C is not constant
Exynos5420 and Exynos5250 supports fifo_depth of 64bytes
Exynos5260 supports fifo_depth of 16bytes

This patch configures the fifo_depth based on HSI2C modules version.
Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/i2c/busses/i2c-exynos5.c |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index cbb49e2..19277d8 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -77,12 +77,6 @@
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
 
@@ -187,6 +181,9 @@ struct exynos5_i2c {
 
 	/* Version of HS-I2C Hardware */
 	unsigned int		version;
+
+	/* FIFO depth */
+	unsigned int		fifo_depth;
 };
 
 enum hsi2c_version {
@@ -437,7 +434,7 @@ static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
 		fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
 		fifo_level = HSI2C_TX_FIFO_LVL(fifo_status);
 
-		len = HSI2C_FIFO_MAX - fifo_level;
+		len = i2c->fifo_depth - fifo_level;
 		if (len > (i2c->msg->len - i2c->msg_ptr))
 			len = i2c->msg->len - i2c->msg_ptr;
 
@@ -505,6 +502,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 	u32 i2c_auto_conf = 0;
 	u32 fifo_ctl;
 	unsigned long flags;
+	unsigned short trig_lvl;
 
 	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
 	i2c_ctl &= ~(HSI2C_TXCHON | HSI2C_RXCHON);
@@ -515,13 +513,19 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 
 		i2c_auto_conf = HSI2C_READ_WRITE;
 
-		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(HSI2C_DEF_TXFIFO_LVL);
+		trig_lvl = (i2c->msg->len > i2c->fifo_depth) ?
+			(i2c->fifo_depth * 3/4) : i2c->msg->len;
+		fifo_ctl |= HSI2C_RXFIFO_TRIGGER_LEVEL(trig_lvl);
+
 		int_en |= (HSI2C_INT_RX_ALMOSTFULL_EN |
 			HSI2C_INT_TRAILING_EN);
 	} else {
 		i2c_ctl |= HSI2C_TXCHON;
 
-		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(HSI2C_DEF_RXFIFO_LVL);
+		trig_lvl = (i2c->msg->len > i2c->fifo_depth) ?
+			(i2c->fifo_depth * 1/4) : i2c->msg->len;
+		fifo_ctl |= HSI2C_TXFIFO_TRIGGER_LEVEL(trig_lvl);
+
 		int_en |= HSI2C_INT_TX_ALMOSTEMPTY_EN;
 	}
 
@@ -716,10 +720,13 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
 	i2c->version = exynos5_i2c_get_version(pdev);
 
 	/* The HS-I2C core on Exynos5260 needs a reset to start with */
-	if (i2c->version == EXYNOS_5260)
+	if (i2c->version == EXYNOS_5260) {
+		i2c->fifo_depth = 16;
 		exynos5_i2c_reset(i2c);
-	else
+	} else {
+		i2c->fifo_depth = 64;
 		exynos5_i2c_init(i2c);
+	}
 
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret < 0) {
-- 
1.7.10.4

