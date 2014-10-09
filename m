Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbaJILeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:34:18 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28785 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaJILeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:34:01 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-5d-543672a7cf34
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/3] ARM: multi_v7_defconfig: Enable Maxim 77836 for Gear2 board
Date: Thu, 09 Oct 2014 13:32:58 +0200
Message-id: <1412854379-18875-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412854379-18875-1-git-send-email-k.kozlowski@samsung.com>
References: <1412854379-18875-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Zd3lRWYhBuencln8nXSM3WLjjPWs
	Fq9fGFr0LrjKZnG26Q27xabH11gtLu+aw2Yx4/w+Jovbl3kt1h65y25x6vpnNgduj5bmHjaP
	378mMXpsXlLvceVEE6tH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZTT/OMRWsJW7Yun/C8wN
	jI1cXYycHBICJhLTehezQNhiEhfurWfrYuTiEBJYyijxbkczC4TTxySxtXs/WBWbgLHE5uVL
	wKpEBH4xSmy7epUJxGEWOMooMb33LRNIlbBAgMTq7avBOlgEVCWWXl/FCGLzCrhL7Hl2iBli
	n5zEyWOTWUFsTgEPiTXzz4L1CgHVtHUeY5zAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5y
	fu4mRkgYftnBuPiY1SFGAQ5GJR7eB/9MQ4RYE8uKK3MPMUpwMCuJ8L7JMgsR4k1JrKxKLcqP
	LyrNSS0+xMjEwSnVwBi85oTxlpCll+wtwtJEe3TceLNkeIrLjJ4JrD/ze+m25bGFt/ce8GW5
	2fhQfYWDdsBpTi5OJv6blcySvGYu+1WvT+vqKn15NFWW9/Sdf9N8f4r+btc8eVZ57ur8eflR
	r7XPSRTbq2TGpy8JiM5mZt2xznCfMkdHYvtquU5rFneXPbwnMze/UGIpzkg01GIuKk4EAEjF
	V9AhAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable all Maxim 14577 drivers and Maxim 17040 fuel gauge driver to
support the Maxim 77836 PMIC present on Samsung Rinato board (Gear 2).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/multi_v7_defconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 9702b140ae04..3d37e9d2914f 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -247,6 +247,8 @@ CONFIG_GPIO_PALMAS=y
 CONFIG_GPIO_TPS6586X=y
 CONFIG_GPIO_TPS65910=y
 CONFIG_BATTERY_SBS=y
+CONFIG_BATTERY_MAX17040=y
+CONFIG_CHARGER_MAX14577=y
 CONFIG_CHARGER_TPS65090=y
 CONFIG_POWER_RESET_AS3722=y
 CONFIG_POWER_RESET_GPIO=y
@@ -266,6 +268,7 @@ CONFIG_MFD_AS3722=y
 CONFIG_MFD_BCM590XX=y
 CONFIG_MFD_CROS_EC=y
 CONFIG_MFD_CROS_EC_SPI=y
+CONFIG_MFD_MAX14577=y
 CONFIG_MFD_MAX8907=y
 CONFIG_MFD_SEC_CORE=y
 CONFIG_MFD_STMPE=y
@@ -277,6 +280,7 @@ CONFIG_REGULATOR_AB8500=y
 CONFIG_REGULATOR_AS3722=y
 CONFIG_REGULATOR_BCM590XX=y
 CONFIG_REGULATOR_GPIO=y
+CONFIG_REGULATOR_MAX14577=y
 CONFIG_REGULATOR_MAX8907=y
 CONFIG_REGULATOR_PALMAS=y
 CONFIG_REGULATOR_S2MPS11=y
@@ -415,6 +419,8 @@ CONFIG_MSM_MMCC_8960=y
 CONFIG_MSM_MMCC_8974=y
 CONFIG_TEGRA_IOMMU_GART=y
 CONFIG_TEGRA_IOMMU_SMMU=y
+CONFIG_EXTCON=y
+CONFIG_EXTCON_MAX14577=y
 CONFIG_MEMORY=y
 CONFIG_IIO=y
 CONFIG_XILINX_XADC=y
-- 
1.9.1

