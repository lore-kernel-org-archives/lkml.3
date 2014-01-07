Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750933AbaAGLwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:52:00 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:21919 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaAGLvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:51:40 -0500
X-AuditID: cbfee68f-b7f156d00000276c-ff-52cbea47685d
From: Naveen Krishna Ch <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/5] crypto:s5p-sss: Exynos5 SoCs too can select SSS driver
Date: Tue, 07 Jan 2014 17:21:48 +0530
Message-id: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkVtf91ekgg2crjCxeHtK0mHO+hcWi
	+5WMxf17P5ksLu+aw2Yx4/w+JotF2/4zW5ydc4jJgcNjy8qbTB47Z91l99h2QNWjb8sqRo/P
	m+QCWKO4bFJSczLLUov07RK4Mo5P+sVc8JGr4sTfTawNjE2cXYycHBICJhKvnr9jh7DFJC7c
	W8/WxcjFISSwlFFi6d//QAkOsKK1G8Mh4osYJSbPbgZrEBLoZ5JYtMUOxGYT0JdYdn0xI4gt
	IuAs8bt5DStIA7PAOkaJl39ns4EkhAW8JeY++QtWxCKgKtHQuJwVxOYVcJXoWXAOapmCxJxJ
	NiBhTgE3idOHLoKFhYBKDh9JAxkpIbCMXWJS9w52iDECEt8mH2KBaJWV2HSAGeIXSYmDK26w
	TGAUXsDIsIpRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjMMxP/3vWv4Px7gHrQ4zJQOMmMkuJ
	JucD4ySvJN7Q2MzIwtTE1NjI3NKMNGElcd77D5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBK
	NTDafd5rqejn1ne2XO/2xsbsRveGP58LiqJOzLJ6/Ob7qz5P38wvnEsMDIO5pqaXl37pm7hI
	Qidb/uEJLosbjSqsi0oLTls3H9V48M4mt7qOd/0ShYfnL9x5yfRALeNuS9Mq2dUP9Z5nFJw6
	y3MmmO+n0Q1nEeV4r0q1qZJv2i5mXZvj8Vur1lyJpTgj0VCLuag4EQBO4CNniQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t9jAV33V6eDDL6v0rJ4eUjTYs75FhaL
	7lcyFvfv/WSyuLxrDpvFjPP7mCwWbfvPbHF2ziEmBw6PLStvMnnsnHWX3WPbAVWPvi2rGD0+
	b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
	AbpESaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxfNIv5oKPXBUn/m5i
	bWBs4uxi5OCQEDCRWLsxvIuRE8gUk7hwbz1bFyMXh5DAIkaJybOb2UESQgL9TBKLttiB2GwC
	+hLLri9mBLFFBJwlfjevYQVpYBZYxyjx8u9sNpCEsIC3xNwnf8GKWARUJRoal7OC2LwCrhI9
	C86xQyxWkJgzyQYkzCngJnH60EWwsBBQyeEjaRMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L
	10vOz93ECI6iZ9I7GFc1WBxiFOBgVOLhfbH3VJAQa2JZcWXuIUYJDmYlEV7mG6eDhHhTEiur
	Uovy44tKc1KLDzEmA900kVlKNDkfGOF5JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJITyxJ
	zU5NLUgtgtnCxMEp1cBoqXpvYWSq1dKnW6PkrFKPqajMeq7ZW2BQZm51rYX/XMbfv7PqnYV0
	hY/lzZ5hqyAe3XO4U0Fr41bFg3LfN03fyHyv02PLhXc5Gw9+3DL74FTv1C/LZnw4vvTy0hcr
	RI49ef/BO+LT9J32Ahai5zjqnscahnCs1yqMuyaTtGNn61nGwxNLzaXfKrEUZyQaajEXFScC
	ADfZM2DmAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch modifies Kconfig such that ARCH_EXYNOS5 SoCs
can also select Samsung SSS(Security SubSystem) driver.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
 drivers/crypto/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f4fd837..137dcd8 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -300,15 +300,15 @@ config CRYPTO_DEV_DCP
 	  capabilities of the DCP co-processor
 
 config CRYPTO_DEV_S5P
-	tristate "Support for Samsung S5PV210 crypto accelerator"
-	depends on ARCH_S5PV210
+	tristate "Support for Samsung crypto accelerator"
+	depends on ARCH_S5PV210 || ARCH_EXYNOS5
 	select CRYPTO_AES
 	select CRYPTO_ALGAPI
 	select CRYPTO_BLKCIPHER
 	help
 	  This option allows you to have support for S5P crypto acceleration.
-	  Select this to offload Samsung S5PV210 or S5PC110 from AES
-	  algorithms execution.
+	  Select this to offload Samsung S5PV210 or S5PC110, Exynos5250
+	  and Exynos5420 from AES algorithms execution.
 
 config CRYPTO_DEV_TEGRA_AES
 	tristate "Support for TEGRA AES hw engine"
-- 
1.7.9.5

