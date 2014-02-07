Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751824AbaBGFXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:23:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23810 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbaBGFW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:22:59 -0500
X-AuditID: cbfee690-b7f266d00000287c-3c-52f46db2e092
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3/9 v6] crypto:s5p-sss: Add support for SSS module on Exynos
Date: Fri, 07 Feb 2014 10:52:41 +0530
Message-id: <1391750561-27316-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-4-git-send-email-ch.naveen@samsung.co>
References: <1389095509-14357-4-git-send-email-ch.naveen@samsung.co>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkWndT7pcgg2NXRS1eHtK0mHO+hcWi
	+5WMxf17P5ksLu+aw2Yx4/w+JotF2/4zW5ydc4jJgcNjy8qbTB47Z91l99h2QNWjb8sqRo/P
	m+QCWKO4bFJSczLLUov07RK4Mjbd+8Je0OpdcXG6awPjdasuRg4OCQETiWczsrsYOYFMMYkL
	99azdTFycQgJLGWU6G76yAqRMJE48ukWM0RiEaPEltt/WCCcfiaJ2zeWMINUsQmYSRxctJod
	xBYRcJb43byGFaSIWWAdo8TLv7PZQBLCAj4SJ+58YwSxWQRUJZ4d+soCYvMKuErsv/WBHeIk
	BYk5k2xAwpxA4Q/vpoG1Cgm4SOzu2MAIMlNCYBm7xMZ9F1gg5ghIfJt8iAWiV1Zi0wFmiKsl
	JQ6uuMEygVF4ASPDKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYzAQD/979mEHYz3DlgfYkwG
	GjeRWUo0OR8YKXkl8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+
	xMjEwSnVwBgd1sD4TWX23fc3m09uyf52gueupj4/S1fFo50Ge/UCvJJNTjK8cuLpa/VfYiFb
	c3XTvBf1oa/8RLNUl/93317y2u3EUT73nVHMZ/zVfvzefbJs24KzSaItHrzVEYIJ1T+F7u1+
	Vf0mLDAsoebPRKPke3MWrNtsf09Ve4LWw0argtCmc9oagUosxRmJhlrMRcWJAKwQCyeKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAd1NuV+CDLpOc1u8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHlpU3mTx2zrrL7rHtgKpH35ZVjB6f
	N8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYczYdO8Le0Grd8XF6a4N
	jNetuhg5OSQETCSOfLrFDGGLSVy4t56ti5GLQ0hgEaPEltt/WCCcfiaJ2zeWgFWxCZhJHFy0
	mh3EFhFwlvjdvIYVpIhZYB2jxMu/s9lAEsICPhIn7nxjBLFZBFQlnh36ygJi8wq4Suy/9QGo
	mQNonYLEnEk2IGFOoPCHd9PAWoUEXCR2d2xgnMDIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66
	XnJ+7iZGcCQ9k97BuKrB4hCjAAejEg/viaWfg4RYE8uKK3MPMUpwMCuJ8HInfAkS4k1JrKxK
	LcqPLyrNSS0+xJgMdNREZinR5HxglOeVxBsam5ibGptamliYmFmSJqwkznuw1TpQSCA9sSQ1
	OzW1ILUIZgsTB6dUAyPX8/J5x/PvfCvJCNGSeX2o6h/fOZX3Dnu0/V9IPWsOiVGybsuZXr7+
	9JQY1wkbCtO3b56V+/yc9pGb8w4tdsxeXSscW/3v5WKGZd995sZ0T6++vuMPs/NH3ybT+HlG
	W5Z/fXEn66CUwjuFyz9rmmZs/5TxS/1swerDS85HHnnxindR7LXgyZ4PlFiKMxINtZiLihMB
	jTvDAOgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new compatible and variant struct to support the SSS
module on Exynos4 (Exynos4210), Exynos5 (Exynos5420 and Exynos5250)
for which
1. AES register are at an offset of 0x200 and
2. hash interrupt is not available

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Change since v5:
1. Rewritten the interrupt definition in the documentation
2. Added Reviewed-by: Tomasz Figa <t.figa@samsung.com>

 .../devicetree/bindings/crypto/samsung-sss.txt     |   15 ++-
 drivers/crypto/s5p-sss.c                           |  107 +++++++++++++++-----
 2 files changed, 95 insertions(+), 27 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
index 3876f71..1702773 100644
--- a/Documentation/devicetree/bindings/crypto/samsung-sss.txt
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -8,16 +8,25 @@ The SSS module in S5PV210 SoC supports the following:
 -- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
 -- PRNG: Pseudo Random Number Generator
 
+The SSS module in Exynos4 (Exynos4210) and
+Exynos5 (Exynos5420 and Exynos5250) SoCs
+supports the following also:
+-- ARCFOUR (ARC4)
+-- True Random Number Generator (TRNG)
+-- Secure Key Manager
+
 Required properties:
 
 - compatible : Should contain entries for this and backward compatible
   SSS versions:
   - "samsung,s5pv210-secss" for S5PV210 SoC.
+  - "samsung,exynos4210-secss" for Exynos4210, Exynos4212, Exynos4412, Exynos5250,
+		Exynos5260 and Exynos5420 SoCs.
 - reg : Offset and length of the register set for the module
 - interrupts : interrupt specifiers of SSS module interrupts, should contain
-		two entries:
-		- first : feed control interrupt,
-		- second : hash interrupt.
+		following entries:
+		- first : feed control interrupt (required for all variants),
+		- second : hash interrupt (required only for samsung,s5pv210-secss).
 
 - clocks : list of clock phandle and specifier pairs for all clocks  listed in
 		clock-names property.
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 73c8b38..da1c8943 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -106,7 +106,7 @@
 #define SSS_REG_FCPKDMAO                0x005C
 
 /* AES registers */
-#define SSS_REG_AES_CONTROL             0x4000
+#define SSS_REG_AES_CONTROL		0x00
 #define SSS_AES_BYTESWAP_DI             _BIT(11)
 #define SSS_AES_BYTESWAP_DO             _BIT(10)
 #define SSS_AES_BYTESWAP_IV             _BIT(9)
@@ -122,21 +122,25 @@
 #define SSS_AES_CHAIN_MODE_CTR          _SBF(1, 0x02)
 #define SSS_AES_MODE_DECRYPT            _BIT(0)
 
-#define SSS_REG_AES_STATUS              0x4004
+#define SSS_REG_AES_STATUS		0x04
 #define SSS_AES_BUSY                    _BIT(2)
 #define SSS_AES_INPUT_READY             _BIT(1)
 #define SSS_AES_OUTPUT_READY            _BIT(0)
 
-#define SSS_REG_AES_IN_DATA(s)          (0x4010 + (s << 2))
-#define SSS_REG_AES_OUT_DATA(s)         (0x4020 + (s << 2))
-#define SSS_REG_AES_IV_DATA(s)          (0x4030 + (s << 2))
-#define SSS_REG_AES_CNT_DATA(s)         (0x4040 + (s << 2))
-#define SSS_REG_AES_KEY_DATA(s)         (0x4080 + (s << 2))
+#define SSS_REG_AES_IN_DATA(s)		(0x10 + (s << 2))
+#define SSS_REG_AES_OUT_DATA(s)		(0x20 + (s << 2))
+#define SSS_REG_AES_IV_DATA(s)		(0x30 + (s << 2))
+#define SSS_REG_AES_CNT_DATA(s)		(0x40 + (s << 2))
+#define SSS_REG_AES_KEY_DATA(s)		(0x80 + (s << 2))
 
 #define SSS_REG(dev, reg)               ((dev)->ioaddr + (SSS_REG_##reg))
 #define SSS_READ(dev, reg)              __raw_readl(SSS_REG(dev, reg))
 #define SSS_WRITE(dev, reg, val)        __raw_writel((val), SSS_REG(dev, reg))
 
+#define SSS_AES_REG(dev, reg)           ((dev)->aes_ioaddr + SSS_REG_##reg)
+#define SSS_AES_WRITE(dev, reg, val)    __raw_writel((val), \
+						SSS_AES_REG(dev, reg))
+
 /* HW engine modes */
 #define FLAGS_AES_DECRYPT               _BIT(0)
 #define FLAGS_AES_MODE_MASK             _SBF(1, 0x03)
@@ -146,6 +150,20 @@
 #define AES_KEY_LEN         16
 #define CRYPTO_QUEUE_LEN    1
 
+/**
+ * struct samsung_aes_variant - platform specific SSS driver data
+ * @has_hash_irq: true if SSS module uses hash interrupt, false otherwise
+ * @aes_offset: AES register offset from SSS module's base.
+ *
+ * Specifies platform specific configuration of SSS module.
+ * Note: A structure for driver specific platform data is used for future
+ * expansion of its usage.
+ */
+struct samsung_aes_variant {
+	bool			    has_hash_irq;
+	unsigned int		    aes_offset;
+};
+
 struct s5p_aes_reqctx {
 	unsigned long mode;
 };
@@ -162,6 +180,7 @@ struct s5p_aes_dev {
 	struct device              *dev;
 	struct clk                 *clk;
 	void __iomem               *ioaddr;
+	void __iomem               *aes_ioaddr;
 	int                         irq_hash;
 	int                         irq_fc;
 
@@ -174,16 +193,48 @@ struct s5p_aes_dev {
 	struct crypto_queue         queue;
 	bool                        busy;
 	spinlock_t                  lock;
+
+	struct samsung_aes_variant *variant;
 };
 
 static struct s5p_aes_dev *s5p_dev;
 
+static const struct samsung_aes_variant s5p_aes_data = {
+	.has_hash_irq	= true,
+	.aes_offset	= 0x4000,
+};
+
+static const struct samsung_aes_variant exynos_aes_data = {
+	.has_hash_irq	= false,
+	.aes_offset	= 0x200,
+};
+
 static const struct of_device_id s5p_sss_dt_match[] = {
-	{ .compatible = "samsung,s5pv210-secss" },
+	{
+		.compatible = "samsung,s5pv210-secss",
+		.data = &s5p_aes_data,
+	},
+	{
+		.compatible = "samsung,exynos4210-secss",
+		.data = &exynos_aes_data,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
 
+static inline struct samsung_aes_variant *find_s5p_sss_version
+				   (struct platform_device *pdev)
+{
+	if (IS_ENABLED(CONFIG_OF) && (pdev->dev.of_node)) {
+		const struct of_device_id *match;
+		match = of_match_node(s5p_sss_dt_match,
+					pdev->dev.of_node);
+		return (struct samsung_aes_variant *)match->data;
+	}
+	return (struct samsung_aes_variant *)
+			platform_get_device_id(pdev)->driver_data;
+}
+
 static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
@@ -329,14 +380,14 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
 {
 	void __iomem *keystart;
 
-	memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
+	memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA (0), iv, 0x10);
 
 	if (keylen == AES_KEYSIZE_256)
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(0);
+		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
 	else if (keylen == AES_KEYSIZE_192)
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(2);
+		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(2);
 	else
-		keystart = dev->ioaddr + SSS_REG_AES_KEY_DATA(4);
+		keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(4);
 
 	memcpy(keystart, key, keylen);
 }
@@ -386,7 +437,7 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
 	if (err)
 		goto outdata_error;
 
-	SSS_WRITE(dev, AES_CONTROL, aes_control);
+	SSS_AES_WRITE(dev, AES_CONTROL, aes_control);
 	s5p_set_aes(dev, dev->ctx->aes_key, req->info, dev->ctx->keylen);
 
 	s5p_set_dma_indata(dev,  req->src);
@@ -571,6 +622,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	struct s5p_aes_dev *pdata;
 	struct device      *dev = &pdev->dev;
 	struct resource    *res;
+	struct samsung_aes_variant *variant;
 
 	if (s5p_dev)
 		return -EEXIST;
@@ -587,6 +639,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 				     resource_size(res), pdev->name))
 		return -EBUSY;
 
+	variant = find_s5p_sss_version(pdev);
+
 	pdata->clk = devm_clk_get(dev, "secss");
 	if (IS_ERR(pdata->clk)) {
 		dev_err(dev, "failed to find secss clock source\n");
@@ -599,6 +653,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	pdata->ioaddr = devm_ioremap(dev, res->start,
 				     resource_size(res));
 
+	pdata->aes_ioaddr = pdata->ioaddr + variant->aes_offset;
+
 	pdata->irq_fc = platform_get_irq(pdev, 0);
 	if (pdata->irq_fc < 0) {
 		err = pdata->irq_fc;
@@ -612,19 +668,22 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	pdata->irq_hash = platform_get_irq(pdev, 1);
-	if (pdata->irq_hash < 0) {
-		err = pdata->irq_hash;
-		dev_warn(dev, "hash interrupt is not available.\n");
-		goto err_irq;
-	}
-	err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
-			       IRQF_SHARED, pdev->name, pdev);
-	if (err < 0) {
-		dev_warn(dev, "hash interrupt is not available.\n");
-		goto err_irq;
+	if (variant->has_hash_irq) {
+		pdata->irq_hash = platform_get_irq(pdev, 1);
+		if (pdata->irq_hash < 0) {
+			err = pdata->irq_hash;
+			dev_warn(dev, "hash interrupt is not available.\n");
+			goto err_irq;
+		}
+		err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
+				       IRQF_SHARED, pdev->name, pdev);
+		if (err < 0) {
+			dev_warn(dev, "hash interrupt is not available.\n");
+			goto err_irq;
+		}
 	}
 
+	pdata->variant = variant;
 	pdata->dev = dev;
 	platform_set_drvdata(pdev, pdata);
 	s5p_dev = pdata;
-- 
1.7.9.5

