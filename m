Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaAGLwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:52:53 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21919 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaAGLve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:51:34 -0500
X-AuditID: cbfee68e-b7f566d000002344-79-52cbea4496da
From: Naveen Krishna Ch <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/5] crypto:s5p-sss: Add device tree and Exynos5 support
Date: Tue, 07 Jan 2014 17:21:46 +0530
Message-id: <1389095509-14357-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkVtfl1ekgg0nXpSxeHtK0mHO+hcWi
	+5WMxf17P5ksLu+aw2Yx4/w+JotF2/4zW5ydc4jJgcNjy8qbTB47Z91l99h2QNWjb8sqRo/P
	m+QCWKO4bFJSczLLUov07RK4Mt5PWMZccESh4tfqe0wNjJukuhg5OSQETCR+PTzEBmGLSVy4
	tx7I5uIQEljKKLHjZSMLTNHzWS8YIRKLGCXWLD3MDuH0M0ns+/6WFaSKTUBfYtn1xYwgtoiA
	s8Tv5jWsIEXMAusYJV7+nQ22Q1jAQ+LglYNgRSwCqhI/zvaDNfMKuEpcfboUaCoH0DoFiTmT
	bEDCnAJuEqcPXQQLCwGVHD6SBjJSQmARu8SnZ5fZIMYISHybfIgFolVWYtMBZoijJSUOrrjB
	MoFReAEjwypG0dSC5ILipPQiI73ixNzi0rx0veT83E2MwFA//e9Z3w7GmwesDzEmA42byCwl
	mpwPjJW8knhDYzMjC1MTU2Mjc0sz0oSVxHkXPUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp
	1cDY6LHcbSH7nU1yNgof5UzerF7dcvar1o17IQ/2r8zZztvTEKNVe0LA+/yauVyqWmmf+Hqn
	Hn/5b/XGJ3OjHdM1bhUL32NtzWaR4sn7MivN3vHM59D+qxevx4iX6yrl3fBL/7nW8J3I3esT
	X05yum2ao6ZQG9tiffNuYNP9h2dDubx1uxg+5zxTYinOSDTUYi4qTgQAsJs2c4sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t9jAV2XV6eDDJ5+E7R4eUjTYs75FhaL
	7lcyFvfv/WSyuLxrDpvFjPP7mCwWbfvPbHF2ziEmBw6PLStvMnnsnHWX3WPbAVWPvi2rGD0+
	b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
	AbpESaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxfsIy5oIjChW/Vt9j
	amDcJNXFyMkhIWAi8XzWC0YIW0ziwr31bF2MXBxCAosYJdYsPcwO4fQzSez7/pYVpIpNQF9i
	2fXFYB0iAs4Sv5vXsIIUMQusY5R4+Xc2G0hCWMBD4uCVg2BFLAKqEj/O9oM18wq4Slx9uhRo
	KgfQOgWJOZNsQMKcAm4Spw9dBAsLAZUcPpI2gZF3ASPDKkbR1ILkguKk9FwjveLE3OLSvHS9
	5PzcTYzgSHomvYNxVYPFIUYBDkYlHt4Xe08FCbEmlhVX5h5ilOBgVhLhZb5xOkiINyWxsiq1
	KD++qDQntfgQYzLQTROZpUST84FRnlcSb2hsYm5qbGppYmFiZkmasJI478FW60AhgfTEktTs
	1NSC1CKYLUwcnFINjGq6lQwlNwLm3A06UtitnHX+F2djs4TTT45NHQmR1wRPi75IzQlztO/6
	GPm3xIJX31ysy7nUKmbzn+rXvTN8n/e/sL8amL2xdv9Cc+FwjcNJs1YnM9v6npmRP3/dOVGr
	z3vcZxxirOzcPFf1QZ33p4rg64lvPV0rfWXTxB9MKf5Ub7Au6dxJJZbijERDLeai4kQAVchN
	p+gCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support along with a new
compatible string to support Exynos5 SoCs (SSS_VER_5).

Also, Documentation under devicetree/bindings added.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
 .../devicetree/bindings/crypto/samsung-sss.txt     |   24 ++++++++++++
 drivers/crypto/s5p-sss.c                           |   40 ++++++++++++++++++++
 2 files changed, 64 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
new file mode 100644
index 0000000..8871a29
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -0,0 +1,24 @@
+Samsung SoC SSS crypto Module
+
+Required properties:
+
+- compatible : Should contain entries for this and backward compatible
+  SSS versions:
+  - "samsung,exynos-secss" for S5PV210.
+  - "samsung,s5p-secss" for Exynos5 series SoCs.
+  TBD: SSS module on Exynos5 SoCs supports other algorithms,
+  support for the is yet to be added in the driver.
+- reg : Offset and length of the register set for the module
+- interrupts : the interrupt-specifier for the SSS module.
+- clocks : the required gating clock for the SSS module.
+- clock-names : the gating clock name requested in the SSS driver.
+
+Example:
+	/* SSS_VER_5 */
+	sss: sss {
+		compatible = "samsung,exynos-secss";
+		reg = <0x10830000 0x10000>;
+		interrupts = <0 112 0>;
+		clocks = <&clock 471>;
+		clock-names = "secss";
+	};
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index dda4551..dcb9fc1 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
 
@@ -173,10 +174,45 @@ struct s5p_aes_dev {
 	struct crypto_queue         queue;
 	bool                        busy;
 	spinlock_t                  lock;
+
+	/* To support SSS versions across Samsung SoCs */
+	unsigned int		    version;
 };
 
 static struct s5p_aes_dev *s5p_dev;
 
+enum sss_version {
+	SSS_VER_4,	/* SSS found on S5PV210 */
+	SSS_VER_5,	/* SSS found on Exynos5 Series SoCs */
+};
+
+static struct platform_device_id s5p_sss_ids[] = {
+	{
+		.name		= "s5p-secss",
+		.driver_data	= SSS_VER_4,
+	}, { },
+};
+MODULE_DEVICE_TABLE(platform, s5p_sss_ids);
+
+static struct of_device_id s5p_sss_dt_match[] = {
+	{ .compatible = "samsung,s5p-secss", .data = (void *)SSS_VER_4 },
+	{ .compatible = "samsung,exynos-secss", .data = (void *)SSS_VER_5 },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
+
+static inline unsigned int find_s5p_sss_version(struct platform_device *pdev)
+{
+#ifdef CONFIG_OF
+	if (pdev->dev.of_node) {
+		const struct of_device_id *match;
+		match = of_match_node(s5p_sss_dt_match, pdev->dev.of_node);
+		return (unsigned int)match->data;
+	}
+#endif
+	return platform_get_device_id(pdev)->driver_data;
+}
+
 static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
@@ -580,6 +616,8 @@ static int s5p_aes_probe(struct platform_device *pdev)
 				     resource_size(res), pdev->name))
 		return -EBUSY;
 
+	pdata->version = find_s5p_sss_version(pdev);
+
 	pdata->clk = devm_clk_get(dev, "secss");
 	if (IS_ERR(pdata->clk)) {
 		dev_err(dev, "failed to find secss clock source\n");
@@ -674,9 +712,11 @@ static int s5p_aes_remove(struct platform_device *pdev)
 static struct platform_driver s5p_aes_crypto = {
 	.probe	= s5p_aes_probe,
 	.remove	= s5p_aes_remove,
+	.id_table	= s5p_sss_ids,
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= "s5p-secss",
+		.of_match_table = s5p_sss_dt_match,
 	},
 };
 
-- 
1.7.9.5

