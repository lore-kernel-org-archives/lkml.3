Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaBGFWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:22:17 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34396 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaBGFWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:22:15 -0500
X-AuditID: cbfee68f-b7f156d00000276c-ff-52f46d851c01
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 2/9 v6] crypto:s5p-sss: Add device tree support
Date: Fri, 07 Feb 2014 10:51:55 +0530
Message-id: <1391750515-27270-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
References: <1389243541-13122-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKLMWRmVeSWpSXmKPExsWyRsSkSrc190uQwb3VphYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLc7OOcTkwOGxZeVNJo+ds+6ye2w7oOrRt2UVo8fn
	TXIBrFFcNimpOZllqUX6dglcGecun2QqmC9WcbOXrYFxl1AXIweHhICJxP25Fl2MnECmmMSF
	e+vZuhi5OIQEljJKHP/XxQKRMJF49nEzE0RiEaPE+uWTmEESQgL9TBIzX0qA2GwCZhIHF61m
	B7FFBJwlfjevYQVpYBZYxyjx8u9sNpCEsIC9xPpPLewgm1kEVCUu7GUFCfMKuEpMvPmUHeIg
	BYk5k2xAwpwCbhKHvh9jgVjlKrHp+loWkJESAsvYJdZ8awMbySIgIPFt8iEWiF5ZiU0HmCFu
	lpQ4uOIGywRG4QWMDKsYRVMLkguKk9KLjPWKE3OLS/PS9ZLzczcxAoP89L9n/TsY7x6wPsSY
	DDRuIrOUaHI+MErySuINjc2MLExNTI2NzC3NSBNWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1
	+BAjEwenVAPjGm9F/z+rDS1/WBXpr+bWFXI7pdQ9YfPzlfzvoz/d6yv+P/F2fOuim7vfS+xR
	PsyqcmedWPce19MnM1bvmy3C8e+9f6jQP6fMtiV7jJkFHZc/Kl3zZqPzoZq2RY41vEp/PVKM
	DDIuVmzIdzsSkbKz/cht5/CF7LpnuV0Dv87xcb6/W3cu7xQlJZbijERDLeai4kQAgFBLnYgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAd3W3C9BBrMO61i8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHlpU3mTx2zrrL7rHtgKpH35ZVjB6f
	N8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcw4d/kkU8F8sYqbvWwN
	jLuEuhg5OSQETCSefdzMBGGLSVy4t56ti5GLQ0hgEaPE+uWTmEESQgL9TBIzX0qA2GwCZhIH
	F61mB7FFBJwlfjevYQVpYBZYxyjx8u9sNpCEsIC9xPpPLUBFHBwsAqoSF/aygoR5BVwlJt58
	ChaWEFCQmDPJBiTMKeAmcej7MRaIVa4Sm66vZZnAyLuAkWEVo2hqQXJBcVJ6rpFecWJucWle
	ul5yfu4mRnAUPZPewbiqweIQowAHoxIP74mln4OEWBPLiitzDzFKcDArifByJ3wJEuJNSays
	Si3Kjy8qzUktPsSYDHTTRGYp0eR8YITnlcQbGpuYmxqbWppYmJhZkiasJM57sNU6UEggPbEk
	NTs1tSC1CGYLEwenVANj+j6nb91pEy3TTwZHri71TFndKRkQn3xl1yGNZs3wqy3ftX7N+Ky0
	e82JO0KqriJ/HDj830grGz3xKTmzXi2p5N+aOfWukw9tnyQ84bGF0K67297o31+2et4dLf0f
	ARnNbsdY5hT8jdnW+qFgaeyG6q6MRjPe7TU5n6tmN9aKP66bd2hT5TtHJZbijERDLeai4kQA
	I5VNOuYCAAA=
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

