Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaIPJiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 05:38:22 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:40463 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbaIPJiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 05:38:14 -0400
X-AuditID: cbfee68d-f79c46d000000b84-86-541805033ccf
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        grundler@chromium.org, linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        cpgs@samsung.com, devicetree@vger.kernel.org
Subject: [PATCH 2/2] i2c: exynos5: Add Kconfig dependencies
Date: Tue, 16 Sep 2014 15:03:18 +0530
Message-id: <1410859998-29285-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1410859998-29285-1-git-send-email-ch.naveen@samsung.com>
References: <1410859998-29285-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkSpeZVSLE4N8nA4uXhzQt5h85x2rx
	6sgPJotNj6+xWnT8/cJocXnXHDaLGef3MVks2vaf2eLblm2MFitPzGJ24PKY3XCRxWPnrLvs
	HpuX1Hv0bVnF6HHy1BMWj8+b5ALYorhsUlJzMstSi/TtErgy9v7ez1Kwi61ix/ojzA2My1m7
	GDk5JARMJCYt3cEIYYtJXLi3nq2LkYtDSGApo8TU+bvYYIo+LT3LCJFYxCixbd8WqKp+Jome
	M9/A2tkEzCQOLlrNDmKLCMhKtD5YwwxSxCzwlVHi0LwnTCAJYQFriUnTDjCD2CwCqhKfnlwE
	i/MKuEqcmNUINIgDaJ2CxJxJNiBhTgE3iZXzNrGAhIWASmbf94Q4aBu7xKmOYogpAhLfJh9i
	geiUldgEMVxCQFLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtQrTswtLs1L10vOz93ECIyE0/+e
	9e5gvH3A+hCjAAejEg+vxyPxECHWxLLiytxDjKZAGyYyS4km5wPjLa8k3tDYzMjC1MTU2Mjc
	0kxJnFdR6mewkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbDwJxvU/dO2F2XeGHR16jd6WoT
	DIKd0pJ75nw213s674eiJ2NfmNuc9VUZT05YCkZmf/J4fqH0fIMRm/3B5+XRT/QPbZFe5sWX
	WHq/POGfc65UxzN+m7Pq58pdOVatjV23d8JdX96D0ztjnfqF/xhurn2zvn/K4Q51PxGLhVd9
	/osXXXc0uqvEUpyRaKjFXFScCABMmwM9fwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t9jAV1mVokQg61vNCxeHtK0mH/kHKvF
	qyM/mCw2Pb7GatHx9wujxeVdc9gsZpzfx2SxaNt/ZotvW7YxWqw8MYvZgctjdsNFFo+ds+6y
	e2xeUu/Rt2UVo8fJU09YPD5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjDmLH3936Wgl1sFTvWH2FuYFzO2sXIySEhYCLxaelZRghbTOLCvfVsXYxcHEICixgltu3b
	AuX0M0n0nPkGVsUmYCZxcNFqdhBbREBWovXBGmaQImaBr4wSh+Y9YQJJCAtYS0yadoAZxGYR
	UJX49OQiWJxXwFXixKxGoEEcQOsUJOZMsgEJcwq4Sayct4kFJCwEVDL7vucERt4FjAyrGEVT
	C5ILipPScw31ihNzi0vz0vWS83M3MYIj7ZnUDsaVDRaHGAU4GJV4eD0eiYcIsSaWFVfmHmKU
	4GBWEuG9+AcoxJuSWFmVWpQfX1Sak1p8iNEU6KaJzFKiyfnAJJBXEm9obGJuamxqaWJhYmap
	JM57oNU6UEggPbEkNTs1tSC1CKaPiYNTqoGRRSm83+//hYxdJ+/ppM7oPSbtzBd3zT0n7smk
	BX+3uoq6XvyTO/v71D73eSx5tqoz81ZJnzh+pb714BUvnviyjfoLWcTOqHxXvyib0ive3PG9
	kk+f39jrTMGtKRPVo3LuHZqynV2cIe/In3C3FUenHn5wbo39+UmF28y0a5NO7U5YcGDVCq1A
	JZbijERDLeai4kQAcuFtdsoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c-exynos5.c driver can be reused for the HSI2C controller
on Exynos7 SoCs from Samsung.

This patch adds the Kconfig dependency to choose i2c-exynos5.c
for CONFIG_ARCH_EXYNOS7.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/i2c/busses/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 2ac87fa..1f3b9cb 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -465,7 +465,7 @@ config I2C_EG20T
 
 config I2C_EXYNOS5
 	tristate "Exynos5 high-speed I2C driver"
-	depends on ARCH_EXYNOS5 && OF
+	depends on ARCH_EXYNOS && OF
 	default y
 	help
 	  High-speed I2C controller on Exynos5 based Samsung SoCs.
-- 
1.7.9.5

