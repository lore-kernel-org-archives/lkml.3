Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaBQJpd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:45:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29241 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbaBQJpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:45:22 -0500
X-AuditID: cbfee68f-b7f156d00000276c-f9-5301da2752a8
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net
Subject: [PATCH 3/9 v7] crypto:s5p-sss: Add support for SSS module on Exynos
Date: Mon, 17 Feb 2014 15:14:29 +0530
Message-id: <1392630275-8667-4-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWyRsSkTlf9FmOwwYzjghYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLc7OOcTkwOGxZeVNJo+ds+6ye2w7oOrRt2UVo8fn
	TXIBrFFcNimpOZllqUX6dglcGb++L2UsmO1dMfX9PuYGxhdWXYycHBICJhL7DuxjhrDFJC7c
	W8/WxcjFISSwlFHi260DjDBFqz+sYIZILGKU6Pv3hxHC6WeSuNu2iR2kik3ATOLgotVgtoiA
	s8Tv5jWsIEXMArMYJWbf/wQ2SljAR+L5sw4mEJtFQFVizfKPYDavgIvE1UdLgGo4gNYpSMyZ
	ZAMS5hRwlei8s50FxBYCKlnXeYkFZKaEwDJ2iW0vb0HNEZD4NvkQC0SvrMSmA1DvSEocXHGD
	ZQKj8AJGhlWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYgcF++t+z/h2Mdw9YH2JMBho3kVlK
	NDkfGC15JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoFxaVi0Vab6BkaWRzxpBb5ia9Q2O5wq/bHirnzksa5MhhDHnvxbJmeSlNtfXLZOVBFiUEy/
	6fh451/OXHfuVws7CrT3mb7J7j/ZdlaKJc3y8f9ZvWEvVq7sbTSQ6H5aXF6fO9+OoXYWv8o9
	O8uX++atuJ/34N6fCqOMzFjVJB1DK/dPL15y9iixFGckGmoxFxUnAgCiw0QGjAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jAV31W4zBBsdesFu8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHlpU3mTx2zrrL7rHtgKpH35ZVjB6f
	N8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcz49X0pY8Fs74qp7/cx
	NzC+sOpi5OSQEDCRWP1hBTOELSZx4d56ti5GLg4hgUWMEn3//jBCOP1MEnfbNrGDVLEJmEkc
	XLQazBYRcJb43byGFaSIWWAWo8Ts+58YQRLCAj4Sz591MIHYLAKqEmuWfwSzeQVcJK4+WgJU
	wwG0TkFiziQbkDCngKtE553tLCC2EFDJus5LLBMYeRcwMqxiFE0tSC4oTkrPNdQrTswtLs1L
	10vOz93ECI6lZ1I7GFc2WBxiFOBgVOLhNahmDBZiTSwrrsw9xCjBwawkwmu7DijEm5JYWZVa
	lB9fVJqTWnyIMRnoqInMUqLJ+cA4zyuJNzQ2MTc1NrU0sTAxsyRNWEmc90CrdaCQQHpiSWp2
	ampBahHMFiYOTqkGxu7pq1K/7DV0PRpywfnT3dVrVtz95K0yR4DP7Jx0UlXW8uP8LjtPfvjf
	f3DSyvqv02f+v7Z3XxL/JEmOTV9Kj1468IL9lPr+me94jt//uD5vd88JNg2Oq28XT4u1Dnjo
	eFuYV6rv4W+FddyPn6sWi32cb+N5fZeoCePhhFkap+ecsg+62fY+a4qPEktxRqKhFnNRcSIA
	VP6IROkCAAA=
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
Change since v6:
None
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
index 73c8b38..fa21db5 100644
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
+	memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA(0), iv, 0x10);
 
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

