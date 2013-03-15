Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3COIEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 04:04:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37789 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841Ab3COIE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 04:04:27 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-52-5142d606becf
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, balbi@ti.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com, p.paneri@samsung.com
Subject: [PATCH v5 3/3] ARM: exynos5: Enable XHCI support on exynos5
Date: Fri, 15 Mar 2013 13:32:14 +0530
Message-id: <1363334534-21901-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
References: <1363334534-21901-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsWyRsSkVpf9mlOgwc1ii4VtS1gsLu+aw2Yx
	4/w+JotFy1qZHVg8Pm+SC2CM4rJJSc3JLEst0rdL4MrY37WMsWATa8WHnVvYGhh3sHQxcnJI
	CJhIXJ+1nR3CFpO4cG89WxcjF4eQwFJGiYXPrgIVcYAVzT6lDBFfxCjxruUhVNEUJonGM5MZ
	QbrZBHQlmt7uArNFBNIlFnz+wARiMwt8Z5TYs5cTxBYWcJFYP+kUWJxFQFXixsPPrCA2r4CH
	xKP9s1ghrlCQeHP7GTOIzSngKfHrQh8jyBFCQDXbXoHtlRB4zSaxbdsLdog5AhLfJh+COlRW
	YtMBZogxkhIHV9xgmcAovICRYRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYHCe/vesfwfj
	3QPWhxiTgcZNZJYSTc4HBndeSbyhsZmRhamJqbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF
	8UWlOanFhxiZODilGhi3PJmmebjWZVq09IU2jZqrot3hgbo26cb3pV+eDJh3LDU0z2WSWP79
	y0VF+1+ttL6wvOfnl/JuBs5tDO5P7f2mRCksVZ/IFLsjdxG758u1tbIWbPyZt4Vdq7MnTyp2
	a3n1sYvj+8qSDczuK/O2iB1Xu1PV+ueNcE3otWN5v+63Zb4p/b5wiq0SS3FGoqEWc1FxIgDY
	HjjJZAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jAV22a06BBvs/mFgsbFvCYnF51xw2
	ixnn9zFZLFrWyuzA4vF5k1wAY1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5
	kkJeYm6qrZKLT4CuW2YO0BIlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEN
	Y8b+rmWMBZtYKz7s3MLWwLiDpYuRg0NCwERi9inlLkZOIFNM4sK99WxdjFwcQgKLGCXetTyE
	cqYwSTSemcwIUsUmoCvR9HYXmC0ikC6x4PMHJhCbWeA7o8SevZwgtrCAi8T6SafA4iwCqhI3
	Hn5mBbF5BTwkHu2fxQqxTUHize1nzCA2p4CnxK8LfYwgBwkB1Wx7xTaBkXcBI8MqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjODgfya1g3Flg8UhRgEORiUe3gP9DoFCrIllxZW5hxglOJiV
	RHg9vRwDhXhTEiurUovy44tKc1KLDzEmAx01kVlKNDkfGJl5JfGGxibmpsamliYWJmaWpAkr
	ifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cB40a3++vP/zDGcbLPbk396ZPMWb3X+q1FeduZ7
	t+3awwsfMNVUTr0VbBL8s/PbUqnylqCW5y8zPcQvSVuuqFzy7U/0QZ3XR9in35vwetWZ+zGZ
	HPlxFQrZl7des7RRlD2pXDstqtz8yZTZP7K2rdZY61sue63ujex2nZlfZOwT9/1/FHF6z9sM
	JZbijERDLeai4kQAWRrElsICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables support for XHCI on exynos5 series of SOCs,
to support host side USB 3.0 support.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/mach-exynos/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index ef3b69a..1c582cf 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -420,6 +420,7 @@ config MACH_EXYNOS5_DT
 	depends on ARCH_EXYNOS5
 	select ARM_AMBA
 	select CLKSRC_OF
+	select USB_ARCH_HAS_XHCI
 	select USE_OF
 	help
 	  Machine support for Samsung EXYNOS5 machine with device tree enabled.
-- 
1.7.6.5

