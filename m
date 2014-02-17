Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbaBQJpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:45:30 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29241 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbaBQJpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:45:24 -0500
X-AuditID: cbfee68e-b7f566d000002344-06-5301da289789
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net,
        Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 4/9 v7] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
Date: Mon, 17 Feb 2014 15:14:30 +0530
Message-id: <1392630275-8667-5-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsWyRsSkRlfjFmOwwevd5hZ3nx9mtHh5SNNi
	zvkWFovuVzIW9+/9ZLK4vGsOm8WM8/uYLBZt+89scXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DKuHX3AFvBB+6Kd1fnsDQwvuHsYuTkkBAwkTj7bz4L
	hC0mceHeerYuRi4OIYGljBKvJuxhgyn61D6RHSKxiFHiwp+XUFX9TBIXnjxgBKliEzCTOLho
	NTuILSLgLPG7eQ0rSBGzwFFGiT3nXoONEhYIkbixfx4riM0ioCpxbdYJMJtXwEXiS/9Tpi5G
	DqB1ChJzJtmAhDkFXCU672wHO08IqGRd5yUWkJkSAuvYJS48P8UCMUdA4tvkQywQvbISmw4w
	Q1wtKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIEhv3pf8/6djDePGB9
	iDEZaNxEZinR5Hxg3OSVxBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpRfFFp
	TmrxIUYmDk6pBsb4splLJ8/Yu+rRn4PvmgVUfnx5JPsk3bjHXP92h9VkLoba6Po5//ZJeq/e
	YjDb0OF5Item+0FmZe/M4jk4HQ7ldbo5/HWSnXXcLW2mBoPBeu/2SKFaW8l8jXW6jU8c3t9/
	tHbKymk2fPoNkjtmO/zO9jwe99oz8Z7KHjk7798HXjxx1LugukaJpTgj0VCLuag4EQAHFPDD
	kQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV2NW4zBBlc26VjcfX6Y0eLlIU2L
	OedbWCy6X8lY3L/3k8ni8q45bBYzzu9jsli07T+zxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8atuwfYCj5w
	V7y7OoelgfENZxcjJ4eEgInEp/aJ7BC2mMSFe+vZuhi5OIQEFjFKXPjzEsrpZ5K48OQBI0gV
	m4CZxMFFq8E6RAScJX43r2EFKWIWOMoosefcazaQhLBAiMSN/fNYQWwWAVWJa7NOgNm8Ai4S
	X/qfMnUxcgCtU5CYM8kGJMwp4CrReWc7C4gtBFSyrvMSywRG3gWMDKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxgqPqmfQOxlUNFocYBTgYlXh4O2sZg4VYE8uKK3MPMUpwMCuJ8NquAwrx
	piRWVqUW5ccXleakFh9iTAY6aiKzlGhyPjDi80riDY1NzE2NTS1NLEzMLEkTVhLnPdhqHSgk
	kJ5YkpqdmlqQWgSzhYmDU6qBcaPjjk/THEJKexk6r+XPuqM5a1vu+Z9XdnhFZtzZeFwrNfyx
	nYrIo5m7XXcdjdCsX9i+/3NMkqnJkjmmXMeYJTle/mT3mBBYYOxrNmHj9Z2HNjw8Za35idPT
	dHNaNseUpHD7Hfx3ft11+hjW/O/JjEc3++tv/ChK0php3SP++p5Rdccxub0PPiqxFGckGmox
	FxUnAgDUsUF47gIAAA==
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
Change since v6:
None

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

