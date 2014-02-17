Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbaBQJpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:45:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:55424 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaBQJpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:45:11 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-46-5301da257b99
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net
Subject: [PATCH 2/9 v7] crypto:s5p-sss: Add device tree support
Date: Mon, 17 Feb 2014 15:14:28 +0530
Message-id: <1392630275-8667-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkWlf1FmOwwZw5xhYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLc7OOcTkwOGxZeVNJo+ds+6ye2w7oOrRt2UVo8fn
	TXIBrFFcNimpOZllqUX6dglcGQ137zEX7BCr6Lxt1sB4VqiLkZNDQsBE4uK+XSwQtpjEhXvr
	2boYuTiEBJYySpzpvcfaxcgBVvT3YyhEfBGjxPFJp1ghnH4miYMzuthAutkEzCQOLlrNDmKL
	CDhL/G5eA1bELDCLUWL2/U+MIAlhAXuJ1vlzmUFsFgFVidcfZoPZvAIuEh8mHGCE2KYgMWeS
	DUiYU8BVovPOdrDrhIBK1nVeYgGZKSGwiF3i6KtGFog5AhLfJh9igeiVldh0gBniG0mJgytu
	sExgFF7AyLCKUTS1ILmgOCm9yFCvODG3uDQvXS85P3cTIzDQT/971ruD8fYB60OMyUDjJjJL
	iSbnAyMlryTe0NjMyMLUxNTYyNzSjDRhJXHepIdJQUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoYXc7Y7RVZmPnz0rp+g0NsXrrZxr9qBKeYXCjL22gfL6Yn5LnxAOMR61y+Wu7YKf2H6s4J
	380+zdzvyaV59pXzlguxbZe3TIjWWfq/bYtpXVEW+/p80SS/6NZnzqHN5/enJ0/aOm1xlulc
	Ty6uzibtuLs2hTH2lhrqIfIzEwM7z0+oc57Sr67EUpyRaKjFXFScCADw//zkigIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAV3VW4zBBm9PaVm8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHlpU3mTx2zrrL7rHtgKpH35ZVjB6f
	N8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcxouHuPuWCHWEXnbbMG
	xrNCXYwcHBICJhJ/P4Z2MXICmWISF+6tZ+ti5OIQEljEKHF80ilWCKefSeLgjC42kCo2ATOJ
	g4tWs4PYIgLOEr+b14AVMQvMYpSYff8TI0hCWMBeonX+XGYQm0VAVeL1h9lgNq+Ai8SHCQcY
	ITYrSMyZZAMS5hRwlei8s50FxBYCKlnXeYllAiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6
	yfm5mxjBcfRMegfjqgaLQ4wCHIxKPLydtYzBQqyJZcWVuYcYJTiYlUR4bdcBhXhTEiurUovy
	44tKc1KLDzEmAx01kVlKNDkfGON5JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJITyxJzU5N
	LUgtgtnCxMEp1cDIfCdoKUvYCov9Vy3Fu9uXzZl9nufI1O1TVaZVNgVUnUy8vaDn29Rrpy/x
	/ch6sFCD4/YX+22TFKY5PNHSf7ZM005v2cRptn2Ju3WNbh6qzSnlkUhZ3cvI8tggdaL+oo3z
	Lk+o2Oimdq78W2uD4uPfz3hkQzImn6leN+1ZheTfNptPTGdnif6UUWIpzkg01GIuKk4EAOyl
	YVvnAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds device tree support to the s5p-sss.c crypto driver.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
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
index 93cddeb..73c8b38 100644
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
@@ -677,6 +684,7 @@ static struct platform_driver s5p_aes_crypto = {
 	.driver	= {
 		.owner	= THIS_MODULE,
 		.name	= "s5p-secss",
+		.of_match_table = s5p_sss_dt_match,
 	},
 };
 
-- 
1.7.9.5

