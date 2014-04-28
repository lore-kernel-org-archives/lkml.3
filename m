Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaD1KtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:49:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52653 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaD1Kq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:46:59 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-76-535e31a250be
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, t.figa@samsung.com, davem@davemloft.net
Subject: [PATCH 2/7 v8] crypto:s5p-sss: Add device tree support
Date: Mon, 28 Apr 2014 16:14:54 +0530
Message-id: <1398681899-20782-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
References: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkVneRYVywwbxFyhYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLdbPeM1icXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DKWDtxGkvBD7GKc8sWsjYwNgt3MXJySAiYSHyZOJ0Z
	whaTuHBvPRuILSSwlFHixhofmJofLa3sEPHpjBJP1/l3MXIB2f1MEn9mvAZrYBMwkzi4aDVY
	kYiAs8Tv5jWsIEXMAusYJT69OcwEkhAWsJc4/6QXrIhFQFViX8dbVhCbV8BV4uiRHsYuRg6g
	bQoScybZgIQ5Bdwkrq4/xwix2FViae8PZpCZEgKr2CX6Nq9hg5gjIPFt8iEWiF5ZiU0HoJ6R
	lDi44gbLBEbhBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECQ/70v2f9OxjvHrA+xJgM
	NG4is5Rocj4wZvJK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4
	ECMTB6dUAyOrCUM3ZzY7x4xHogd/vFjFo/ZL+aWUoGf8PdPmUgXzvzuy2eZdjtscfp5L66pR
	5p3LRyderXly3TG7db/Kf/GzdbI3n3p8/qF1MVNkVtPTF5fjgxsWy+34sy2v//9aYYlztgEe
	cny9s36wGPhrr9KNeNR1InPfJ1WRe94ZkznvLVHybhdr3azEUpyRaKjFXFScCABkTXmFjwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd1FhnHBBu2fpCxeHtK0mHO+hcWi
	+5WMxf17P5ksLu+aw2Yx4/w+JotF2/4zW6yf8ZrF4uycQ0wOnB5bVt5k8tg56y67x7YDqh59
	W1YxenzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMWPtxGksBT/E
	Ks4tW8jawNgs3MXIySEhYCLxo6WVHcIWk7hwbz0biC0kMJ1R4uk6/y5GLiC7n0niz4zXYAk2
	ATOJg4tWgzWICDhL/G5ewwpSxCywjlHi05vDTCAJYQF7ifNPesGKWARUJfZ1vGUFsXkFXCWO
	Hulh7GLkANqmIDFnkg1ImFPATeLq+nOMEItdJZb2/mCewMi7gJFhFaNoakFyQXFSeq6hXnFi
	bnFpXrpecn7uJkZwTD2T2sG4ssHiEKMAB6MSD2/EnNhgIdbEsuLK3EOMEhzMSiK8+yXigoV4
	UxIrq1KL8uOLSnNSiw8xJgMdNZFZSjQ5HxjveSXxhsYm5qbGppYmFiZmlqQJK4nzHmi1DhQS
	SE8sSc1OTS1ILYLZwsTBKdXA6MIXeubmr6LzaSf/fz15Rav+/iqRSpYrj4+vbDVcdsPkRWj5
	SffUctvVmTYSzzpFwiPOZ59Z2sWkFNx3a12VRG9Abdbu2YbWZqL3I//sTpVIuGMqPXUN/1w5
	rcacqbcvfFx8ZE9zeaD85t/nQ5JmxrAcXMgmOLP877bLvyZ/u8T3PpTzs661ohJLcUaioRZz
	UXEiALgItKTtAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to the s5p-sss.c crypto driver.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v7:
Added Acked-by from Herbert Xu
Changes since v6:
None
Changes since v5:
Rewritten the interrupt definition in the documentation

 .../devicetree/bindings/crypto/samsung-sss.txt     |   26 ++++++++++++++++++++
 drivers/crypto/s5p-sss.c                           |    8 ++++++
 2 files changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
new file mode 100644
index 0000000..3876f71
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -0,0 +1,26 @@
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
+- interrupts : interrupt specifiers of SSS module interrupts, should contain
+		two entries:
+		- first : feed control interrupt,
+		- second : hash interrupt.
+
+- clocks : list of clock phandle and specifier pairs for all clocks  listed in
+		clock-names property.
+- clock-names : list of device clock input names; should contain one entry
+		"secss".
+
diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 2876fa3..c6aafe8 100644
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
+	{ .compatible = "samsung,s5pv210-secss" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, s5p_sss_dt_match);
+
 static void s5p_set_dma_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 {
 	SSS_WRITE(dev, FCBRDMAS, sg_dma_address(sg));
@@ -672,6 +679,7 @@ static struct platform_driver s5p_aes_crypto = {
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= "s5p-secss",
+		.of_match_table = s5p_sss_dt_match,
 	},
 };
 
-- 
1.7.9.5

