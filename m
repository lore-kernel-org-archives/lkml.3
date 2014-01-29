Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaA2JVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:21:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61671 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaA2JVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:21:07 -0500
X-AuditID: cbfee690-b7f266d00000287c-06-52e8c801c88b
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/9 v5] crypto:s5p-sss: Add device tree support
Date: Wed, 29 Jan 2014 14:50:59 +0530
Message-id: <1390987259-18581-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkWpfxxIsgg1t7JS1eHtK0mHO+hcVi
	/pFzrBbdr2Qs7t/7yWRxedccNosZ5/cxWSza9p/Z4uycQ0wOnB5bVt5k8tg56y67x7YDqh59
	W1YxenzeJBfAGsVlk5Kak1mWWqRvl8CVcen2T8aCTvGKg807GRsYJwp3MXJySAiYSJxduJ4J
	whaTuHBvPVsXIxeHkMBSRok7n+czwxTtmn2LHSIxnVHi2cUFTBBOP5PErBvzGUGq2ATMJA4u
	Ws0OYosIOEv8bl7DClLELHCKUWJ601k2kISwgL3E3p9NYEUsAqoSn3Y+ZwWxeQVcJZbMbgWy
	OYDWKUjMmWQDEuYUcJM49P0YC4gtBFSy6fpaFpCZEgLr2CX+zN/BCDFHQOLb5EMsEL2yEpsO
	QF0tKXFwxQ2WCYzCCxgZVjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmIEhv3pf88m7GC8d8D6
	EGMy0LiJzFKiyfnAuMkriTc0NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBsbQRcvK+h5cudqUfSY2b1nlMh9Pi/kGLwpU1y/OLRPP4jqToOmwryfXMirl
	urx7pXIG39wi/bPPf/45cO/dztg03uYijX527dULmdp6zs59OC1PfHnTT0Md1e1Tf7/JTJus
	1ugSJHHhdeH6O8q7rn7N2LWutsp7+vLegOv9f43Prm71alSJElFiKc5INNRiLipOBACuaa/G
	kQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jQV3GEy+CDH5/ELR4eUjTYs75FhaL
	+UfOsVp0v5KxuH/vJ5PF5V1z2CxmnN/HZLFo239mi7NzDjE5cHpsWXmTyWPnrLvsHtsOqHr0
	bVnF6PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKL
	T4CuW2YO0DlKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoxLt38yFnSK
	Vxxs3snYwDhRuIuRk0NCwERi1+xb7BC2mMSFe+vZuhi5OIQEpjNKPLu4gAnC6WeSmHVjPiNI
	FZuAmcTBRavBOkQEnCV+N69hBSliFjjFKDG96SwbSEJYwF5i788msCIWAVWJTzufs4LYvAKu
	EktmtwLZHEDrFCTmTLIBCXMKuEkc+n6MBcQWAirZdH0tywRG3gWMDKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxgqPqmdQOxpUNFocYBTgYlXh4V1x8HiTEmlhWXJl7iFGCg1lJhPfEphdB
	QrwpiZVVqUX58UWlOanFhxiTgY6ayCwlmpwPjPi8knhDYxNzU2NTSxMLEzNL0oSVxHkPtFoH
	CgmkJ5akZqemFqQWwWxh4uCUamB0k7t44FHqlLTuy3/brZ/omFhevM5WqH2nl/O6gYF0q9Vh
	85vntu5bG5R5SZl7z8UpuZMaar6I5HYeXhnx8lhxerHdaU7djxXP5X++WfrPLleY7fox+1ul
	WlM4Vj6ZzCThpCqyz9pn9tMTG/0sN/YmL+o3+Hhsu/G1T2f7GDi0duw8fuHvivUPlViKMxIN
	tZiLihMBVjrIJO4CAAA=
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
Changes since v4:
Modified Documentation to give clock names and example for interrupts

Changes since v3:
None
 .../devicetree/bindings/crypto/samsung-sss.txt     |   24 ++++++++++++++++++++
 drivers/crypto/s5p-sss.c                           |    8 +++++++
 2 files changed, 32 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/samsung-sss.txt

diff --git a/Documentation/devicetree/bindings/crypto/samsung-sss.txt b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
new file mode 100644
index 0000000..d193084
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/samsung-sss.txt
@@ -0,0 +1,24 @@
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
+	   Eg : interrupts = <0 feed-control 0> <0 hash 0>;
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

