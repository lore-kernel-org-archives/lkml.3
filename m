Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaE1KQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:16:27 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22844 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaE1KQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:16:24 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-0a-5385b7747664
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Tushar Behera <tushar.behera@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH] ARM: exynos_defconfig: Enable clock and RTC driver for S2M and
 S5M
Date: Wed, 28 May 2014 12:16:07 +0200
Message-id: <1401272167-3125-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFJMWRmVeSWpSXmKPExsVy+t/xq7ol21uDDV6f0bXYOGM9q8XrF4YW
	vQuuslmcbXrDbrHp8TVWi8u75rBZzDi/j8ni9mVei7VH7rJbnLr+mc3i5J9eRov2v3vZHHg8
	Wpp72DzuXNvD5rF5Sb3HlRNNrB59W1YxenzeJBfAFsVlk5Kak1mWWqRvl8CVsW/hLvaCKWwV
	+3t+sjQwrmbtYuTkkBAwkZi+9wgzhC0mceHeerYuRi4OIYGljBKnjl1nhXD6mCTOHZ8BVsUm
	YCyxefkSNhBbRGA9k8TcXw4gRcwCRxklpve+ZQJJCAuEStz9uZodxGYRUJV4M/c4mM0r4Cax
	7MATqHVyEiePTWadwMi9gJFhFaNoamlyQXFSeq6hXnFibnFpXrpecn7uJkZIeH3Zwbj4mNUh
	RgEORiUe3gWyrcFCrIllxZW5hxglOJiVRHidlgKFeFMSK6tSi/Lji0pzUosPMTJxcEo1MHbm
	ZrftPyz//cNK2Y0sant453ZUbX2aMDm34ZPSxQ71sLPvT8U1LPklwXnqiMTGgN+aiw/uU8g1
	f/zFwUXs67dXb5dLlcmU7vsxPd5IPKGGTfPAvTtcq1NTYx54F/+KWGP6pXjBB6uwOM1Pbkmu
	37Ratu3rEs23npjx/cijQzyaCtytf57rVSixFGckGmoxFxUnAgBQ0qJWDQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The config enables already Samsung's PMIC-s MFD driver and regulators
(S2MPS11 and S5M8767). Enable also drivers for rest of these PMIC-s
features: clock and RTC.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/exynos_defconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index e07a227ec0db..f69b86b650fa 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -109,7 +109,9 @@ CONFIG_MMC_DW_IDMAC=y
 CONFIG_MMC_DW_EXYNOS=y
 CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_S3C=y
+CONFIG_RTC_DRV_S5M=y
 CONFIG_COMMON_CLK_MAX77686=y
+CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT3_FS=y
 CONFIG_EXT4_FS=y
-- 
1.9.1

