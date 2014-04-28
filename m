Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaD1JBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:01:49 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32100 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbaD1JBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:01:46 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-c9-535e18f855bf
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        linux-kernel@vger.kernel.org, wsa@the-dreams.de, cpgs@samsung.com,
        broonie@kernel.org, t.figa@samsung.com
Subject: [PATCH] i2c: exynos5: add support for HSI2C on Exynos5260 SoC
Date: Mon, 28 Apr 2014 14:29:58 +0530
Message-id: <1398675598-25991-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsWyRsSkTveHRFywwa7ffBZTHz5hs3h5SNNi
	0+NrrBYdf78wWlzeNYfNYsb5fUwWi7b9Z7b4tmUbo8X6Ga9ZLFaemMXswOUxu+Eii8fOWXfZ
	PTat6mTz2Lyk3qNvyypGj5OnnrB4fN4kF8AexWWTkpqTWZZapG+XwJXx9N8jloI1BhXty6Yy
	NjBeVe9i5OSQEDCROPzyPyuELSZx4d56ti5GLg4hgaWMElOfPmeEKZo1fSpUYhGjxK6dR1gg
	nH4mieO/f4O1swmYSRxctJodxBYRkJVofbCGGaSIWeAVo8St+T+B2jk4hAXcJHqWSYHUsAio
	Skxb8JwNxOYVcJX4dOQeWImEgILEnEk2EIuXsUs8bjSHKBeQ+Db5EAtEiazEpgPMECWSEgdX
	3GCZwCi4gJFhFaNoakFyQXFSepGpXnFibnFpXrpecn7uJkZgiJ/+92ziDsb7B6wPMSYDjZvI
	LCWanA+MkbySeENjMyMLUxNTYyNzSzPShJXEedMfJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYHRT0O03/z3/7t+O8zqhRkaWLT+UqtP2liksWXx8X+zF3fPOvFu2of9UApfh/Gq105dC
	9897wZav8uxymXPRxnlVZ5u+LchbKlRxc88Xs888y7Om+MmIX+dZZxiwcWbfMosPka+Zy99a
	Z+le2T1RuJpDzmi11LfAUO6Yg9v+b/aJFpwskK3/xUCJpTgj0VCLuag4EQBRCFZdhwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jAd0fEnHBBltuslhMffiEzeLlIU2L
	TY+vsVp0/P3CaHF51xw2ixnn9zFZLNr2n9ni25ZtjBbrZ7xmsVh5YhazA5fH7IaLLB47Z91l
	99i0qpPNY/OSeo++LasYPU6eesLi8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjKf/HrEUrDGoaF82lbGB8ap6FyMnh4SAicSs6VPZIGwxiQv31gPZXBxCAosY
	JXbtPMIC4fQzSRz//ZsVpIpNwEzi4KLV7CC2iICsROuDNcwgRcwCrxglbs3/CdTOwSEs4CbR
	s0wKpIZFQFVi2oLnYBt4BVwlPh25B1YiIaAgMWeSzQRG7gWMDKsYRVMLkguKk9JzjfSKE3OL
	S/PS9ZLzczcxgmPomfQOxlUNFocYBTgYlXh4I+bEBguxJpYVV+YeYpTgYFYS4S1giwsW4k1J
	rKxKLcqPLyrNSS0+xJgMtHwis5Rocj4wvvNK4g2NTcxNjU0tTSxMzCxJE1YS5z3Yah0oJJCe
	WJKanZpakFoEs4WJg1OqgTH1br/F21rW9HyzI73zeGT/sLUsqXrzOsI4vP67aVLU44eLJVXX
	TrtWr+e202qL2//j1SvVbSf8WBHbqy+7yHwep5SS+llufp7bAcc04z+u2TkrmufbVbklzC82
	XynUPbJyreuWN+sYty9MDS88aC9WqBjBlq1ePFMxLzkqv0jzgcva61atAUosxRmJhlrMRcWJ
	ALrFNcHlAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HSI2C module on Exynos5260 differs from current modules in
following ways:
1.  HSI2C on Exynos5260 has fifo_depth of 16bytes
2.  Module needs to be reset as a part of init sequence.

Hence, Following changes are involved.
1. Add a new compatible string and Updates the Documentation dt bindings.
2. Introduce a variant struct to support the changes in H/W
3. Reset the module during init. Thus, bringing the module back
to default state irrespective of what firmware did with it.

Signed-off-by: Naveen Krishna Chatradhi <ich.naveen@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
This patch is under review at https://lkml.org/lkml/2014/2/6/590
and https://lkml.org/lkml/2014/2/6/151

As per Wolfram's comments, both the patches were squashed here.

 .../devicetree/bindings/i2c/i2c-exynos5.txt        |   11 +++-
 drivers/i2c/busses/i2c-exynos5.c                   |   67 ++++++++++++++++----
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
index 056732c..d4745e3 100644
--- a/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-exynos5.txt
@@ -5,7 +5,14 @@ at various speeds ranging from 100khz to 3.4Mhz.
 
 Required properties:
   - compatible: value should be.
-      -> "samsung,exynos5-hsi2c", for i2c compatible with exynos5 hsi2c.
+	-> "samsung,exynos5-hsi2c", (DEPRECATED)
+				for i2c compatible with HSI2C available
+				on Exynos5250 and Exynos5420 SoCs.
+	-> "samsung,exynos5250-hsi2c", for i2c compatible with HSI2C available
+				on Exynos5250 and Exynos5420 SoCs.
+	-> "samsung,exynos5260-hsi2c", for i2c compatible with HSI2C available
+				on Exynos5260 SoCs.
+
   - reg: physical base address of the controller and length of memory mapped
     region.
   - interrupts: interrupt number to the cpu.
@@ -26,7 +33,7 @@ Optional properties:
 Example:
 
 hsi2c@12ca0000 {
-	compatible = "samsung,exynos5-hsi2c";
+	compatible = "samsung,exynos5250-hsi2c";
 	reg = <0x12ca0000 0x100>;
 	interrupts = <56>;
 	clock-frequency = <100000>;
diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 00af0a0..043d6d8 100644
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
 
@@ -183,14 +177,54 @@ struct exynos5_i2c {
 	 * 2. Fast speed upto 1Mbps
 	 */
 	int			speed_mode;
+
+	/* Version of HS-I2C Hardware */
+	struct exynos_hsi2c_variant	*variant;
+};
+
+/**
+ * struct exynos_hsi2c_variant - platform specific HSI2C driver data
+ * @fifo_depth: the fifo depth supported by the HSI2C module
+ *
+ * Specifies platform specific configuration of HSI2C module.
+ * Note: A structure for driver specific platform data is used for future
+ * expansion of its usage.
+ */
+struct exynos_hsi2c_variant {
+	unsigned int	fifo_depth;
+};
+
+static const struct exynos_hsi2c_variant exynos5250_hsi2c_data = {
+	.fifo_depth	= 64,
+};
+
+static const struct exynos_hsi2c_variant exynos5260_hsi2c_data = {
+	.fifo_depth	= 16,
 };
 
 static const struct of_device_id exynos5_i2c_match[] = {
-	{ .compatible = "samsung,exynos5-hsi2c" },
-	{},
+	{
+		.compatible = "samsung,exynos5-hsi2c",
+		.data = &exynos5250_hsi2c_data
+	}, {
+		.compatible = "samsung,exynos5250-hsi2c",
+		.data = &exynos5250_hsi2c_data
+	}, {
+		.compatible = "samsung,exynos5260-hsi2c",
+		.data = &exynos5260_hsi2c_data
+	}, {},
 };
 MODULE_DEVICE_TABLE(of, exynos5_i2c_match);
 
+static inline struct exynos_hsi2c_variant *exynos5_i2c_get_variant
+					(struct platform_device *pdev)
+{
+	const struct of_device_id *match;
+
+	match = of_match_node(exynos5_i2c_match, pdev->dev.of_node);
+	return (struct exynos_hsi2c_variant *)match->data;
+}
+
 static void exynos5_i2c_clr_pend_irq(struct exynos5_i2c *i2c)
 {
 	writel(readl(i2c->regs + HSI2C_INT_STATUS),
@@ -415,7 +449,7 @@ static irqreturn_t exynos5_i2c_irq(int irqno, void *dev_id)
 		fifo_status = readl(i2c->regs + HSI2C_FIFO_STATUS);
 		fifo_level = HSI2C_TX_FIFO_LVL(fifo_status);
 
-		len = HSI2C_FIFO_MAX - fifo_level;
+		len = i2c->variant->fifo_depth - fifo_level;
 		if (len > (i2c->msg->len - i2c->msg_ptr))
 			len = i2c->msg->len - i2c->msg_ptr;
 
@@ -483,6 +517,7 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 	u32 i2c_auto_conf = 0;
 	u32 fifo_ctl;
 	unsigned long flags;
+	unsigned short trig_lvl;
 
 	i2c_ctl = readl(i2c->regs + HSI2C_CTL);
 	i2c_ctl &= ~(HSI2C_TXCHON | HSI2C_RXCHON);
@@ -493,13 +528,19 @@ static void exynos5_i2c_message_start(struct exynos5_i2c *i2c, int stop)
 
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
 
@@ -691,7 +732,9 @@ static int exynos5_i2c_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_clk;
 
-	exynos5_i2c_init(i2c);
+	i2c->variant = exynos5_i2c_get_variant(pdev);
+
+	exynos5_i2c_reset(i2c);
 
 	ret = i2c_add_adapter(&i2c->adap);
 	if (ret < 0) {
-- 
1.7.9.5

