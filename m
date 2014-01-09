Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaAIE7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:59:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54735 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaAIE7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:59:38 -0500
X-AuditID: cbfee68d-b7fcd6d00000315b-65-52ce2cb9604b
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/6 v2] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
Date: Thu, 09 Jan 2014 10:29:55 +0530
Message-id: <1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42JZI2JSp7tT51yQQeMjXou7zw8zWrw8pGkx
	53wLi0X3KxmL+/d+Mllc3jWHzWLG+X1MFou2/We2WLXrD6PF2TmHmBy4PLasvMnksXPWXXaP
	bQdUPfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugStj0/OD7AVzeCuuP1jL2sD4l6uLkZNDQsBE
	YvbX8+wQtpjEhXvr2boYuTiEBJYySvzpv8sGU3Ry2k+oxCJGifdrJ7JAOP1MEsu3XWUEqWIT
	MJM4uGg12CgRAWeJ381rWEGKmAU+MUo0rF/FCpIQFgiROPHyEguIzSKgKnGhdw4ziM0r4Cox
	+9RCoGYOoHUKEnMm2YCEOQXcJNY+vw82UwioZPuZr+wgMyUEtrFLvFn1ghlijoDEt8mHWCB6
	ZSU2HWCGuFpS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiMgNP/nvXu
	YLx9wPoQYzLQuInMUqLJ+cAIyiuJNzQ2M7IwNTE1NjK3NCNNWEmcN+lhUpCQQHpiSWp2ampB
	alF8UWlOavEhRiYOTqkGxgUddmcvJp2IEJ5Qmnym6pCdx2Kvxq1PNvwLWu1iNn/HL45o/sbe
	U4u+tr7fvKPE+4JBy6SEf21R2bFzb+5c8uR4gMQO/b8HNz198sZxGi/jj65NZitPrOs7IMku
	7OAieJ7jKmd10dZXRQK1NZ1zsp8Fd6YqZyxJVH9x9noxy93UlClXpXUTJyuxFGckGmoxFxUn
	AgCmt6aWlgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jAd2dOueCDK6vYba4+/wwo8XLQ5oW
	c863sFh0v5KxuH/vJ5PF5V1z2CxmnN/HZLFo239mi1W7/jBanJ1ziMmBy2PLyptMHjtn3WX3
	2HZA1aNvyypGj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPIS
	c1NtlVx8AnTdMnOAblJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZmx6
	fpC9YA5vxfUHa1kbGP9ydTFyckgImEicnPaTDcIWk7hwbz2QzcUhJLCIUeL92oksEE4/k8Ty
	bVcZQarYBMwkDi5azQ5iiwg4S/xuXsMKUsQs8IlRomH9KlaQhLBAiMSJl5dYQGwWAVWJC71z
	mEFsXgFXidmnFgI1cwCtU5CYM8kGJMwp4Cax9vl9sJlCQCXbz3xln8DIu4CRYRWjaGpBckFx
	UnqukV5xYm5xaV66XnJ+7iZGcHw9k97BuKrB4hCjAAejEg/viuKzQUKsiWXFlbmHGCU4mJVE
	eP+qngsS4k1JrKxKLcqPLyrNSS0+xJgMdNREZinR5Hxg7OeVxBsam5ibGptamliYmFmSJqwk
	znuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6OWpDoD56lXpxIsF3+x27DYecvMnfqlvwseGlq0
	CD3pvboj946T5L97J5l+RF9/Wno0/sbqv20L906cdPXLYfOSlti7P5P27Vq/uIW5KSq1weux
	aZOsaO7re6s7nP7PfBmdvOBAp7hiS5wQb2qjdlj26zWi7dz/wlLnG7s5RqudenPtp1JF9BIl
	luKMREMt5qLiRABpIwXO8wIAAA==
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
Changes since v1:
SSS module on Exynos4210 and Exynos5250, Exynso5420 are alike
hence, modifying the Kconfig to select the s5p-sss.c driver
for all SoCs supporting ARCH_EXYNOS

 drivers/crypto/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f4fd837..193e8b1 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -300,15 +300,15 @@ config CRYPTO_DEV_DCP
 	  capabilities of the DCP co-processor
 
 config CRYPTO_DEV_S5P
-	tristate "Support for Samsung S5PV210 crypto accelerator"
-	depends on ARCH_S5PV210
+	tristate "Support for Samsung crypto accelerator"
+	depends on ARCH_S5PV210 || ARCH_EXYNOS
 	select CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for S5P crypto acceleration.
-	  Select this to offload Samsung S5PV210 or S5PC110 from AES
-	  algorithms execution.
+	  Select this to offload Samsung S5PV210 or S5PC110, Exynos4210,
+	  Exynos5250 and Exynos5420 from AES algorithms execution.
 
 config CRYPTO_DEV_TEGRA_AES
 	tristate "Support for TEGRA AES hw engine"
-- 
1.7.9.5

