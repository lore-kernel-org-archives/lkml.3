Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaBGFXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:23:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23917 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaBGFXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:23:41 -0500
X-AuditID: cbfee68e-b7f566d000002344-48-52f46ddc2769
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4/9 v6] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
Date: Fri, 07 Feb 2014 10:53:23 +0530
Message-id: <1391750603-27370-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkSvdO7pcgg9aF4hZ3nx9mtHh5SNNi
	zvkWFovuVzIW9+/9ZLK4vGsOm8WM8/uYLBZt+89scXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DK+D95AWvBNe6KH9szGhhvcXYxcnJICJhIHHhwmBHC
	FpO4cG89WxcjF4eQwFJGiben97DDFD2//ogZIrGIUWLG3ulQVf1MEtdP3AOrYhMwkzi4aDWY
	LSLgLPG7eQ0rSBGzwG1GiUXH3rKAJIQFQiQ6f68E28cioCqx8MseoEkcHLwCrhKH5yaCmBIC
	ChJzJtmAVHAKuEmsfX4fbKQQUMX2M1/ZQUZKCKxil9h49zU7xBgBiW+TD7FA9MpKbDrADHG0
	pMTBFTdYJjAKL2BkWMUomlqQXFCclF5kpFecmFtcmpeul5yfu4kRGPKn/z3r28F484D1IcZk
	oHETmaVEk/OBMZNXEm9obGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhgrZryf2nnwBo/JjTnv7VgCA03tq53cnBYv4rkXVDKP+dahYg5G0xzfz44nl2la
	PWJSenxyQrRB3vXPLV775ql+Ej7XaqsVYdrhw23NkbEgivnne4XKKCGOcxrMjVferN6aLvVU
	46j/Yo3SuB9/1fqPsZ+ovRn91UX2u9Ld7bJ9qn7FZ7sUXimxFGckGmoxFxUnAgDXAfNEjwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jAd07uV+CDG7f4LG4+/wwo8XLQ5oW
	c863sFh0v5KxuH/vJ5PF5V1z2CxmnN/HZLFo239mi7NzDjE5cHpsWXmTyWPnrLvsHtsOqHr0
	bVnF6PF5k1wAa1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKL
	T4CuW2YO0DlKCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoz/kxewFlzj
	rvixPaOB8RZnFyMnh4SAicTz64+YIWwxiQv31rN1MXJxCAksYpSYsXc6lNPPJHH9xD12kCo2
	ATOJg4tWg9kiAs4Sv5vXsIIUMQvcZpRYdOwtC0hCWCBEovP3SkYQm0VAVWLhlz1Akzg4eAVc
	JQ7PTQQxJQQUJOZMsgGp4BRwk1j7/D7YSCGgiu1nvrJPYORdwMiwilE0tSC5oDgpPddQrzgx
	t7g0L10vOT93EyM4op5J7WBc2WBxiFGAg1GJh/fE0s9BQqyJZcWVuYcYJTiYlUR4uRO+BAnx
	piRWVqUW5ccXleakFh9iTAa6aSKzlGhyPjDa80riDY1NzE2NTS1NLEzMLEkTVhLnPdBqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qB0eTq86hLEYt8TZ0LQs7fnVWRdLLnhobD4ejDjhPDv5fdSulz
	u1D/3k/1yXrtqckHJhkHse/NtnaaLXgn4yBTmUjjTZUOhanFX09fEt4i7H6cV0T40tXdFxI6
	vG35P2f53eR5r3dy+vI1zdsvLVa/UJUwOWbF3uDoz3aHHRoCxGOubr/qzSvWosRSnJFoqMVc
	VJwIAGzbBWDsAgAA
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
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Change since v5:
None

 drivers/crypto/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 13857f5..e866489 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -290,14 +290,14 @@ config CRYPTO_DEV_SAHARA
 	  found in some Freescale i.MX chips.
 
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

