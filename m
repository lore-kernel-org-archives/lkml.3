Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaAJLnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:43:10 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:44360 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaAJLnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:43:06 -0500
X-AuditID: cbfee68e-b7f566d000002344-87-52cfdcc9a34a
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/8 v3] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
Date: Fri, 10 Jan 2014 17:13:22 +0530
Message-id: <1389354202-31891-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSrXvyzvkgg/UntC3uPj/MaPHykKbF
	nPMtLBbdr2Qs7t/7yWRxedccNosZ5/cxWSza9p/ZYtWuP4wWZ+ccYnLg8tiy8iaTx85Zd9k9
	th1Q9ejbsorR4/MmuQDWKC6blNSczLLUIn27BK6Mwy0bGQsaeSpWXe1ibmD8xdnFyMkhIWAi
	sXXJFiYIW0ziwr31bF2MXBxCAksZJTqP3GeFKeq++4sRIrGIUeLyhCUsEE4/k8S+480sIFVs
	AmYSBxetZgexRQScJX43r2EFKWIW+MQo0bB+FdgoYYEQif7dXxhBbBYBVYk5X1aANfAKuEqc
	2jwXKM4BtE5BYs4kG5Awp4CbxNrn98FKhIBKtp/5yg5x0SZ2iZPHNSDGCEh8m3yIBaJVVmLT
	AWaIEkmJgytusExgFF7AyLCKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzD8T/971reD8eYB
	60OMyUDjJjJLiSbnA+MnryTe0NjMyMLUxNTYyNzSjDRhJXHeRQ+TgoQE0hNLUrNTUwtSi+KL
	SnNSiw8xMnFwSjUwenoopTY/WCnoWbly1gxNhpAo5VXnzzy3SlO0lRAyCXvLalbHGtQtPWfJ
	zWs8y7rMm+8VxjD6lWYq3OM8ceTVoif5P/JO3dUw3tw8J2leyJb6df4JbM+PTK24EOGo68US
	6W4Y6H94mr3B/qgC/Q2/HpQ6T1gZwZFUfvzX2dz78w1ZNmYceHFeiaU4I9FQi7moOBEAkaHJ
	NZUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jAd2Td84HGXzoV7S4+/wwo8XLQ5oW
	c863sFh0v5KxuH/vJ5PF5V1z2CxmnN/HZLFo239mi1W7/jBanJ1ziMmBy2PLyptMHjtn3WX3
	2HZA1aNvyypGj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPIS
	c1NtlVx8AnTdMnOAblJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZhxu
	2chY0MhTsepqF3MD4y/OLkZODgkBE4nuu78YIWwxiQv31rN1MXJxCAksYpS4PGEJC4TTzySx
	73gzC0gVm4CZxMFFq9lBbBEBZ4nfzWtYQYqYBT4xSjSsX8UKkhAWCJHo3/0FbCyLgKrEnC8r
	wBp4BVwlTm2eCxTnAFqnIDFnkg1ImFPATWLt8/tgJUJAJdvPfGWfwMi7gJFhFaNoakFyQXFS
	eq6RXnFibnFpXrpecn7uJkZwfD2T3sG4qsHiEKMAB6MSD2/BrPNBQqyJZcWVuYcYJTiYlUR4
	zS8AhXhTEiurUovy44tKc1KLDzEmAx01kVlKNDkfGPt5JfGGxibmpsamliYWJmaWpAkrifMe
	bLUOFBJITyxJzU5NLUgtgtnCxMEp1cCYF2r48MyfkEXxYmfUr0lmLkj+/PUqv9lny+yAyNgJ
	x/TKap02CG0LFnn3r9qh6tmu1u0v5huITb5/dnnLzOLcFTvZbqx/sfGm72vXPAn+5BS7+NOu
	PXMTp3BwVuzm2H/uxBPxQs911TZfX8VOZD1VlzLZrF7MXT9x8R1bXevX7EEWtumRhzcqsRRn
	JBpqMRcVJwIAdskbavMCAAA=
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
Changes since v2:
None

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

