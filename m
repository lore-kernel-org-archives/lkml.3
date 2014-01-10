Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaAJLmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:42:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35486 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaAJLmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:42:02 -0500
X-AuditID: cbfee68e-b7f566d000002344-c2-52cfdc880c45
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/8 v3] crypto:s5p-sss: Add device tree support
Date: Fri, 10 Jan 2014 17:12:18 +0530
Message-id: <1389354138-31784-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsWyRsSkRrfjzvkgg+3/rSxeHtK0mHO+hcWi
	+5WMxf17P5ksLu+aw2Yx4/w+JotF2/4zW6za9YfR4uycQ0wOnB5bVt5k8tg56y67x7YDqh59
	W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CVsXdDL2PBe7GKt0e3MjUwtgl3MXJySAiYSJyeOI0N
	whaTuHBvPZDNxSEksJRRYm/zY9YuRg6wolUf+CDi0xkl9u38BlXUzyQx894zdpBuNgEziYOL
	VoPZIgLOEr+b17CCFDELHGWU+DznIhNIQljAXqJlzhdmEJtFQFVi6c5eFhCbV8BVYseWCSwQ
	2xQk5kyyAQlzCrhJHPp+DKxECKhk0/W1LCAzJQRWsUvMe3+FCWKOgMS3yYegemUlNh1ghvhG
	UuLgihssExiFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIDPrT/5717WC8ecD6EGMy
	0LiJzFKiyfnAqMkriTc0NjOyMDUxNTYytzQjTVhJnHfRw6QgIYH0xJLU7NTUgtSi+KLSnNTi
	Q4xMHJxSDYw2hg4zj8S+K2++/S2w4WOiHoeBarYq/89IE2npXbO+OZzgLDbIbTt1UPsRu2Za
	ibpesvO8iUdEll2IrZKSDInZpTDnQDXzPocHz9T4M2NKXjA0b/jM9iZo8WzugKWLZD5bRsp/
	SGvrM1y+yOzP7NvbMy8yy3vp7Kjr3dO+bfLMnGmsgo8Y1JRYijMSDbWYi4oTAa6g99CQAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd2OO+eDDJ71GVu8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntli16w+jxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8beDb2MBe/F
	Kt4e3crUwNgm3MXIwSEhYCKx6gNfFyMnkCkmceHeerYuRi4OIYHpjBL7dn6DcvqZJGbee8YO
	UsUmYCZxcNFqMFtEwFnid/MaVpAiZoGjjBKf51xkAkkIC9hLtMz5wgxiswioSizd2csCYvMK
	uErs2DKBBWKzgsScSTYgYU4BN4lD34+BlQgBlWy6vpZlAiPvAkaGVYyiqQXJBcVJ6bmGesWJ
	ucWleel6yfm5mxjBMfVMagfjygaLQ4wCHIxKPLwFs84HCbEmlhVX5h5ilOBgVhLhNb8AFOJN
	SaysSi3Kjy8qzUktPsSYDHTURGYp0eR8YLznlcQbGpuYmxqbWppYmJhZkiasJM57oNU6UEgg
	PbEkNTs1tSC1CGYLEwenVAOjBV+w+cWSE1PN4r2nsnsnX9Bd/kN5k+Sj9gXxkiXSln2rrdr+
	e5myszFti5udpPSmZ1bM/ba5X+b1RWcuXOLwOETQwrKkM/j27aBUb4+3M8TjbvzaE3rF6VHF
	JJ/DF4x6D+4XW8KU6toi8e2kOh/Dhxtr/6XVizn+NOwuy8qd5OI/xWHzeg4lluKMREMt5qLi
	RABFahhX7QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to the s5p-sss.c crypto driver.

Also, Documentation under devicetree/bindings added.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v2:
1. Moved the variant struct part to the Exynos support patch
2. Changed the compatible strings to s5pv210-secss

 .../devicetree/bindings/crypto/samsung-sss.txt     |   20 ++++++++++++++++++++
 drivers/crypto/s5p-sss.c                           |   10 +++++++++-
 2 files changed, 29 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
new file mode 100644
index 0000000..2f9d7e4
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -0,0 +1,20 @@
+Samsung SoC SSS (Security SubSystem) module
+
+The SSS module in S5PV210 SoC supports the following:
+-- Feeder (FeedCtrl)
+-- Advanced Encryption Standard (AES)
+-- Data Encryption Standard (DES)/3DES
+-- Public Key Accelerator (PKA)
+-- SHA-1/SHA-256/MD5/HMAC (SHA-1/SHA-256/MD5)/PRNG
+-- PRNG: Pseudo Random Number Generator
+
+Required properties:
+
+- compatible : Should contain entries for this and backward compatible
+  SSS versions:
+  - "samsung,s5pv210-secss" for S5PV210 SoC.
+- reg : Offset and length of the register set for the module
+- interrupts : the interrupt-specifier for the SSS module.
+		Two interrupts "feed control and hash" in case of S5PV210
+- clocks : the required gating clock for the SSS module.
+- clock-names : the gating clock name to be requested in the SSS driver.
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 93cddeb..2da5617 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -22,6 +22,7 @@
 #include <linux/scatterlist.h>
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
+#include <linux/of.h>
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
 
@@ -177,6 +178,12 @@ struct s5p_aes_dev {
 
 static struct s5p_aes_dev *s5p_dev;
 
+static const struct of_device_id s5p_sss_dt_match[] = {
+	{ .compatible = "samsung,s5pv210-secss", },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
+
 static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
@@ -676,7 +683,8 @@ static struct platform_driver s5p_aes_crypto = {
 	.remove	= s5p_aes_remove,
 	.driver	= {
 		.owner	= THIS_MODULE,
-		.name	= "s5p-secss",
+		.name	= "s5pv210-secss",
+		.of_match_table = s5p_sss_dt_match,
 	},
 };
 
-- 
1.7.9.5

