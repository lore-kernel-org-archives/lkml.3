Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaJILe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:34:27 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:44846 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaJILeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:34:02 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-5e-543672a7e311
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/3] ARM: multi_v7_defconfig: Enable clock and RTC driver for
 S2M and S5M
Date: Thu, 09 Oct 2014 13:32:59 +0200
Message-id: <1412854379-18875-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412854379-18875-1-git-send-email-k.kozlowski@samsung.com>
References: <1412854379-18875-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Zd3lRWYhButWaFr8nXSM3WLjjPWs
	Fq9fGFr0LrjKZnG26Q27xabH11gtLu+aw2Yx4/w+Jovbl3kt1h65y25x6vpnNgduj5bmHjaP
	378mMXpsXlLvceVEE6tH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZfxav4W9oJOzYsq6PWwN
	jM/Zuxg5OSQETCSuN9xlhrDFJC7cW8/WxcjFISSwlFGie/lOKKePSWJr934WkCo2AWOJzcuX
	gCVEBH4xSmy7epUJxGEWOMooMb33LRNIlbBAtMSy6ffBbBYBVYmGKRsYQWxeAXeJh1u+skHs
	k5M4eWwyK4jNKeAhsWb+WbB6IaCats5jjBMYeRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vO
	z93ECAnDLzsYFx+zOsQowMGoxMP74J9piBBrYllxZe4hRgkOZiUR3jdZZiFCvCmJlVWpRfnx
	RaU5qcWHGJk4OKUaGBnXTkirFJ1twqFysTbmCcPpV99nfFf+43W6efLWqw+ac61/3Dnzv372
	i9uGm67Of5T81sPnv0HUJQvLxGXLD9sasn1fyesRn9X8TP3zyh8q+skCb35n7L2msKd8r+Sp
	vA/mIY/nua25MqdJf134nlVG63wv/458opJ6QX+u8Yo0zmM3fVst694psRRnJBpqMRcVJwIA
	v63H4yECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The multi_v7 config already enables MFD and regulators drivers for
Samsung's S2MPS11/S2MPS14 and S5M8767. Enable also drivers for the rest
of these PMICs features: clock and RTC.

These PMICs are used on Arndale (Exynos 5250 and 5420) and Origen
(Exynos 4412) evaluation boards, Google Spring, Samsung Gear2 (Exynos
3250) and some other phones based on Exynos5.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/multi_v7_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 3d37e9d2914f..1a60a69f26ad 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -391,6 +391,7 @@ CONFIG_RTC_DRV_SUN6I=y
 CONFIG_RTC_DRV_SUNXI=y
 CONFIG_RTC_DRV_MV=y
 CONFIG_RTC_DRV_TEGRA=y
+CONFIG_RTC_DRV_S5M=y
 CONFIG_DMADEVICES=y
 CONFIG_DW_DMAC=y
 CONFIG_MV_XOR=y
@@ -414,6 +415,7 @@ CONFIG_NVEC_POWER=y
 CONFIG_NVEC_PAZ00=y
 CONFIG_QCOM_GSBI=y
 CONFIG_COMMON_CLK_QCOM=y
+CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_MSM_GCC_8660=y
 CONFIG_MSM_MMCC_8960=y
 CONFIG_MSM_MMCC_8974=y
-- 
1.9.1

