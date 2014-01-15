Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaAOJOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:14:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:22780 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaAOJOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:14:39 -0500
X-AuditID: cbfee690-b7f266d00000287c-06-52d6517e50ae
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/8 v4] crypto:s5p-sss: Add device tree support
Date: Wed, 15 Jan 2014 14:44:51 +0530
Message-id: <1389777291-15026-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkSrcu8FqQQc85MYuXhzQt5pxvYbHo
	fiVjcf/eTyaLy7vmsFnMOL+PyWLRtv/MFqt2/WG0ODvnEJMDp8eWlTeZPHbOusvuse2Aqkff
	llWMHp83yQWwRnHZpKTmZJalFunbJXBlHL20lKWgWazi+eT/LA2Ma4S6GDk5JARMJJa+nMcK
	YYtJXLi3nq2LkYtDSGApo8T7ed9ZYIo6+z+xQyQWMUocXbuUCcLpZ5K42PCaCaSKTcBM4uCi
	1ewgtoiAs8Tv5jWsIEXMAkcZJT7PuQhWJCxgL/Fv9kc2EJtFQFWiZdVnsAZeAVeJky/fAcU5
	gNYpSMyZZAMS5hRwkzj0/RjYFUJAJZuur2UBmSkhsIpd4t75XVBzBCS+TT7EAtErK7HpADPE
	1ZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmDYn/73bMIOxnsHrA8x
	JgONm8gsJZqcD4ybvJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgFGfnfLAybleghAVDw5NdH+XXHkq7v9B5mVbMh8hV8h3ZHpxHYq5G5X42TJsb
	Nem70wtOhQQR98apr5quhabs3V61N6dC6ZnfBm6D3PNFwlf8MnYuff9wt1GcTO3uWxtSJY56
	XZjSLllgtcG9wylzevSub2kvsk1+ati27Z3B75SYvS9Y7k2dEktxRqKhFnNRcSIA8u1i+ZEC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAd26wGtBBmt7+CxeHtK0mHO+hcWi
	+5WMxf17P5ksLu+aw2Yx4/w+JotF2/4zW6za9YfR4uycQ0wOnB5bVt5k8tg56y67x7YDqh59
	W1YxenzeJBfAGtXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+Ti
	E6DrlpkDdI6SQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePopaUsBc1i
	Fc8n/2dpYFwj1MXIySEhYCLR2f+JHcIWk7hwbz1bFyMXh5DAIkaJo2uXMkE4/UwSFxteM4FU
	sQmYSRxctBqsQ0TAWeJ38xpWkCJmgaOMEp/nXAQrEhawl/g3+yMbiM0ioCrRsuozWAOvgKvE
	yZfvgOIcQOsUJOZMsgEJcwq4SRz6fowFxBYCKtl0fS3LBEbeBYwMqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGCo+qZ1A7GlQ0WhxgFOBiVeHh/hF8NEmJNLCuuzD3EKMHBrCTCK+VzLUiI
	NyWxsiq1KD++qDQntfgQYzLQUROZpUST84ERn1cSb2hsYm5qbGppYmFiZkmasJI474FW60Ah
	gfTEktTs1NSC1CKYLUwcnFINjLN2ne7X0z275qSZeHiZNdeXc/eW3dmodiHi9K+8gpfRf5LT
	1GzWHZFTv679dZ8Ln4TtnfyDgnMns28/f+jYH1YnF2ufVm2b608dA8y807dp8IWzKZa3mKav
	rk/T+KFVO792mVHXbVPhh/+POjd92bkhTXTxpPRPHxgDHA58629osNAS6+hmUmIpzkg01GIu
	Kk4EAFWaD0LuAgAA
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
Changes since v3:
None

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

