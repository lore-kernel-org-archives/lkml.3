Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbaKTFs5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 00:48:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34518 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103AbaKTFsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 00:48:55 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-5a-546d80c5075d
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        pankaj.dubey@samsung.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v3 5/5] arm: exynos: Select SOC_SAMSUNG config option
Date: Thu, 20 Nov 2014 11:09:28 +0530
Message-id: <1416461968-2057-6-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
References: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWyRsSkWvdoQ26Iwfu32hYNV0MsehdcZbPY
	9Pgaq8XlXXPYLGac38dksWjrF3YHNo/NS+o9+rasYvT4vEkugDmKyyYlNSezLLVI3y6BK6Pt
	3nH2ggusFa3TZjA3MF5g6WLk5JAQMJFY+usxE4QtJnHh3nq2LkYuDiGBpYwSTcs2MsMUXb97
	hhUisYhRYtOnT2AdQgITmCROn5YEsdkEjCV+7tzP3sXIwSEi4C2x/JoiSD2zQBOjxLl5l1lB
	aoQFXCXWXljKBmKzCKhK/LzZygpSzyvgJvHyNTeIKSGgIDFnkg1IBaeAu8TzT3sYITa5SZxa
	sZgJZKSEQDO7xN+WL+wQYwQkvk0+xALRKyux6QDUyZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6
	kYlecWJucWleul5yfu4mRmAAn/73bMIOxnsHrA8xCnAwKvHwJljkhgixJpYVV+YeYjQF2jCR
	WUo0OR8YJ3kl8YbGZkYWpiamxkbmlmZK4ryvpX4GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amBUO+mX13bpyydL02ZTlufWK9vj5+7+ns1UyMCxMoLpyo/zKm/Meq6b7XnJVtfd5PV29t2n
	oVHpVmXeFTIKVQ3JXz+aWd9pZDX8uorVQWBipw+TzVItW9OvrNfdcl482ZBsXVk5/crxZ06L
	zCaxzPJPPVKns04yUvkzg3bxWZs5c53+TdpxWUqJpTgj0VCLuag4EQA1d5+AWwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jAd2jDbkhBg9aVSwaroZY9C64ymax
	6fE1VovLu+awWcw4v4/JYtHWL+wObB6bl9R79G1ZxejxeZNcAHNUA6NNRmpiSmqRQmpecn5K
	Zl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBaJYWyxJxSoFBAYnGxkr4dpgmh
	IW66FjCNEbq+IUFwPUYGaCBhDWNG273j7AUXWCtap81gbmC8wNLFyMkhIWAicf3uGVYIW0zi
	wr31bF2MXBxCAosYJTZ9+sQEkhASmMAkcfq0JIjNJmAs8XPnfvYuRg4OEQFvieXXFEHqmQWa
	GCXOzbsMNkhYwFVi7YWlbCA2i4CqxM+brawg9bwCbhIvX3ODmBICChJzJtmAVHAKuEs8/7SH
	EWKTm8SpFYuZJjDyLmBkWMUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHB/PpHcwrmqwOMQo
	wMGoxMObYJEbIsSaWFZcmXuIUYKDWUmE91MlUIg3JbGyKrUoP76oNCe1+BCjKdBNE5mlRJPz
	gbGbVxJvaGxibmpsamliYWJmqSTOe7DVOlBIID2xJDU7NbUgtQimj4mDU6qBcWqIvNXPxUon
	OG229TOuuvRq4zVtlR0FPPMZzDtqJLmiLR0Z8k/8mijGxD074K/cieBdDqoysl6HOjyfSJ5b
	6/31Zs/0X8v+WZ6tXH3AnLHvfY1O0d+Vv9wm6E+L+nnE+9KKN5ICFee/6ho2rWz7/qBJ+l7b
	Q/PbOrMfXfhw+v2JMuu2kof3PZVYijMSDbWYi4oTAQcBrfKlAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config option SOC_SAMSUNG is needed to enable all soc samsung
drivers inside driver/soc/samsung folder. Currently, this will be useful to
enable exynos pmu driver which is moved to that folder.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 arch/arm/mach-exynos/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index b9e3f1c..17880b6 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -25,6 +25,7 @@ menuconfig ARCH_EXYNOS
 	select S5P_DEV_MFC
 	select SRAM
 	select MFD_SYSCON
+	select SOC_SAMSUNG
 	help
 	  Support for SAMSUNG EXYNOS SoCs (EXYNOS4/5)
 
-- 
1.7.9.5

