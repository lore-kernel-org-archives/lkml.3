Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaA2JWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:22:44 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16121 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbaA2JWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:22:41 -0500
X-AuditID: cbfee690-b7f266d00000287c-20-52e8c8606205
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, devicetree@vger.kernel.org,
        Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/9 v5] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
Date: Wed, 29 Jan 2014 14:52:34 +0530
Message-id: <1390987354-18665-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
References: <1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSo5tw4kWQQc8zDou7zw8zWrw8pGkx
	53wLi8X8I+dYLbpfyVjcv/eTyeLyrjlsFjPO72OyWLTtP7PF2TmHmBy4PLasvMnksXPWXXaP
	bQdUPfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvj9fd/LAV/uCvaVsxkamD8ydnFyMkhIWAi
	0byilRnCFpO4cG89WxcjF4eQwFJGiS2t31lhitrb5rGD2EIC0xkl3t2rgyjqZ5KYfGkXWIJN
	wEzi4KLVYLaIgLPE7+Y1rCBFzALfGSXmNE1lAUkIC4RIfJl5G8xmEVCVuNHUBlTEwcEr4Crx
	d5sEiCkhoCAxZ5INSAWngJvE7rWPGCH2uko0f98GdegmdoklbyUhpghIfJt8iAWiVVZi0wGo
	EkmJgytusExgFF7AyLCKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIzD0T/97NmEH470D1ocY
	k4HGTWSWEk3OB8ZOXkm8obGZkYWpiamxkbmlGWnCSuK8ao+SgoQE0hNLUrNTUwtSi+KLSnNS
	iw8xMnFwSjUwmmz89dr41xErif26XatuXl4qftTn8Zp9Dh8eu834c7H62q0rU/Pl/2qc9Z4j
	59G7TNaw78WLi5OKY30vL129q66icInSFb/S8GqVR9xGFXLLjizkFre/u1czvat0+fYXnsu3
	l59dOo9nj1Rb/nVlu5tMb25Gfby+/hmHiFxAlwXHJ/6UG+3hL5VYijMSDbWYi4oTAYBJPKqT	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQd34Ey+CDDa12ljcfX6Y0eLlIU2L
	OedbWCzmHznHatH9Ssbi/r2fTBaXd81hs5hxfh+TxaJt/5ktzs45xOTA5bFl5U0mj52z7rJ7
	bDug6tG3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJ
	uam2Si4+AbpumTlANykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM15/
	/8dS8Ie7om3FTKYGxp+cXYycHBICJhLtbfPYIWwxiQv31rOB2EIC0xkl3t2r62LkArL7mSQm
	X9oFVsQmYCZxcNFqMFtEwFnid/MaVpAiZoHvjBJzmqaygCSEBUIkvsy8DWazCKhK3GhqAyri
	4OAVcJX4u00CxJQQUJCYM8kGpIJTwE1i99pHjBB7XSWav29jnsDIu4CRYRWjaGpBckFxUnqu
	kV5xYm5xaV66XnJ+7iZGcGw9k97BuKrB4hCjAAejEg/viovPg4RYE8uKK3MPMUpwMCuJ8J7Y
	9CJIiDclsbIqtSg/vqg0J7X4EGMy0E0TmaVEk/OBcZ9XEm9obGJuamxqaWJhYmZJmrCSOO/B
	VutAIYH0xJLU7NTUgtQimC1MHJxSDYy+/5WPhguv5VTWtZmv6PC2L2bn85cyrDFnDggtYlxz
	/mCndHiwMNv8J/febjfcr/W8ar9GcM7lldrp+ppHuBs7jOTMMi9ah77O3Pz0YrwGa6joh5ir
	7xm+X3rjEjdb7f2S/SV6811WzP8T7D3DZ7fWrKTVS6MP3uIPcf19zG3LFienM6aLdtsqsRRn
	JBpqMRcVJwIAuY+JrPECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Ch <ch.naveen@samsung.com>

This patch modifies Kconfig such that ARCH_EXYNOS SoCs
which includes (Exynos4210, Exynos5250 and Exynos5420)
can also select Samsung SSS(Security SubSystem) driver.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v4:
none
Changes since v3:
Modified description to use "Exynos" instead of individual SoC name
 drivers/crypto/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f4fd837..cb38863 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -300,14 +300,14 @@ config CRYPTO_DEV_DCP
 	  capabilities of the DCP co-processor
 
 config CRYPTO_DEV_S5P
-	tristate "Support for Samsung S5PV210 crypto accelerator"
-	depends on ARCH_S5PV210
+	tristate "Support for Samsung S5PV210/Exynos crypto accelerator"
+	depends on ARCH_S5PV210 || ARCH_EXYNOS
 	select CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for S5P crypto acceleration.
-	  Select this to offload Samsung S5PV210 or S5PC110 from AES
+	  Select this to offload Samsung S5PV210 or S5PC110, Exynos from AES
 	  algorithms execution.
 
 config CRYPTO_DEV_TEGRA_AES
-- 
1.7.9.5

