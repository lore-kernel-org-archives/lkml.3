Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaAOJPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:15:46 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:22248 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaAOJPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:15:36 -0500
X-AuditID: cbfee690-b7f266d00000287c-3b-52d651b118a2
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/8 v4] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
Date: Wed, 15 Jan 2014 14:45:43 +0530
Message-id: <1389777343-15108-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
References: <1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSq7sx8FqQwf+fWhZ3nx9mtHh5SNNi
	zvkWFovuVzIW9+/9ZLK4vGsOm8WM8/uYLBZt+89ssWrXH0aLs3MOMTlweWxZeZPJY+esu+we
	2w6oevRtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfG0o2XmAueclc8+bqapYHxGWcXIyeHhICJ
	xMu+o0wQtpjEhXvr2boYuTiEBJYySvxbPoUJpmjzyn52iMR0RomeHe0sIAkhgX4miTVvZEBs
	NgEziYOLVrOD2CICzhK/m9ewgjQwC3xilGhYv4oVJCEsECLxctsksCIWAVWJ21sWMoPYvAKu
	EjPWnABazQG0TUFiziQbkDCngJvE7rWPGCF2uUo0f9/GDDJTQmAbu8Sm7j9QcwQkvk0+xALR
	Kyux6QAzxNGSEgdX3GCZwCi8gJFhFaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZg+J/+92zC
	DsZ7B6wPMSYDjZvILCWanA+Mn7ySeENjMyMLUxNTYyNzSzPShJXEedUeJQUJCaQnlqRmp6YW
	pBbFF5XmpBYfYmTi4JRqYMwIXDdfI3yX9Qxn+aQV3yRUX/l9WGq86rRMTOABkZpJVqocV0vl
	WPyTNDb6ZDqHrz4dMdu18KZc3ycO/kQe5QeP/vcrPH+r8vsq/7mH7K/DhSd83M9Vu+n9DO1q
	Z4UGEZ5NlpPKuZ5Z59mEPnkz4/ycl4JlGXv0WPbei861MdfeWT1tZtn/aCWW4oxEQy3mouJE
	AB4STsGVAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jQd2NgdeCDFZdVbC4+/wwo8XLQ5oW
	c863sFh0v5KxuH/vJ5PF5V1z2CxmnN/HZLFo239mi1W7/jBanJ1ziMmBy2PLyptMHjtn3WX3
	2HZA1aNvyypGj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPIS
	c1NtlVx8AnTdMnOAblJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZizd
	eIm54Cl3xZOvq1kaGJ9xdjFyckgImEhsXtnPDmGLSVy4t56ti5GLQ0hgOqNEz452FpCEkEA/
	k8SaNzIgNpuAmcTBRavBGkQEnCV+N69hBWlgFvjEKNGwfhUrSEJYIETi5bZJYEUsAqoSt7cs
	ZAaxeQVcJWasOQG0gQNom4LEnEk2IGFOATeJ3WsfMULscpVo/r6NeQIj7wJGhlWMoqkFyQXF
	Sem5RnrFibnFpXnpesn5uZsYwdH1THoH46oGi0OMAhyMSjy8P8KvBgmxJpYVV+YeYpTgYFYS
	4ZXyuRYkxJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnAyM8riTc0NjE3NTa1NLEwMbMkTVhJ
	nPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsbeRzcDVNOmpjQK7FBRNPH/kCt/aee+31GfJWQC
	6k0U+drOX5h6JavCn2HpG7Y17o9V713Pzy7oE/j/Zr4gX281U5XekeIADqc7/M6FzL9drASO
	7tX/efGc5zXNs9NvLtm+pEY/7J/lg08r8n88Wm4wobzzy+LJNy9um9Jzb2VBJHfioRMPBduU
	WIozEg21mIuKEwEiejpx8gIAAA==
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

