Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaJILeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 07:34:10 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61988 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJILeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 07:34:01 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-b9-543672a6dbfd
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/3] ARM: exynos_defconfig: Enable Maxim 77836 for Gear2 board
Date: Thu, 09 Oct 2014 13:32:57 +0200
Message-id: <1412854379-18875-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7rLisxCDC7tULf4O+kYu8XGGetZ
	LV6/MLToXXCVzeJs0xt2i02Pr7FaXN41h81ixvl9TBa3L/NarD1yl93i1PXPbA7cHi3NPWwe
	v39NYvTYvKTe48qJJlaPvi2rGD0+b5ILYIvisklJzcksSy3St0vgyri+5jt7wTzuivNd+5gb
	GJ9xdjFyckgImEhcm3qVDcIWk7hwbz2QzcUhJLCUUeLL+d0sEE4fk8SFW/PBqtgEjCU2L18C
	ViUi8ItRYtvVq0wgDrPAUUaJ6b1vmUCqhAX8JL5/OsACYrMIqEoc/dDHDGLzCrhLTFn4nxli
	n5zEyWOTWScwci9gZFjFKJpamlxQnJSea6RXnJhbXJqXrpecn7uJERJWX3cwLj1mdYhRgINR
	iYf3wT/TECHWxLLiytxDjBIczEoivG+yzEKEeFMSK6tSi/Lji0pzUosPMTJxcEo1MF4I0ao9
	stbkgTn/l7jSlz+EPp1jE7jidbnxXMr0q+lqi/PbjloxXGRmjfZznu+q6eW9sPTK/zMMJze3
	qVwKvab5PnHJOcGVMsVKIWqvrQ7MqkzhlLsf8YItleGCRWAH7zLZHt6kwPsKmxTFZJInnc/M
	2fulLufiwcsfNyy4U/vGVtzlR0f+bCWW4oxEQy3mouJEANXFgtIJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable all Maxim 14577 drivers and Maxim 17040 fuel gauge driver to
support the Maxim 77836 PMIC present on Samsung Rinato board (Gear 2).

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 arch/arm/configs/exynos_defconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index b14d8c3f7e12..ce600b654297 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -78,6 +78,8 @@ CONFIG_SPI_S3C64XX=y
 CONFIG_DEBUG_GPIO=y
 CONFIG_POWER_SUPPLY=y
 CONFIG_BATTERY_SBS=y
+CONFIG_BATTERY_MAX17040=y
+CONFIG_CHARGER_MAX14577=y
 CONFIG_CHARGER_TPS65090=y
 # CONFIG_HWMON is not set
 CONFIG_THERMAL=y
@@ -88,6 +90,7 @@ CONFIG_S3C2410_WATCHDOG=y
 CONFIG_MFD_CROS_EC=y
 CONFIG_MFD_CROS_EC_I2C=y
 CONFIG_MFD_CROS_EC_SPI=y
+CONFIG_MFD_MAX14577=y
 CONFIG_MFD_MAX77686=y
 CONFIG_MFD_MAX77693=y
 CONFIG_MFD_MAX8997=y
@@ -95,6 +98,7 @@ CONFIG_MFD_SEC_CORE=y
 CONFIG_MFD_TPS65090=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_GPIO=y
+CONFIG_REGULATOR_MAX14577=y
 CONFIG_REGULATOR_MAX8997=y
 CONFIG_REGULATOR_MAX77686=y
 CONFIG_REGULATOR_MAX77693=y
@@ -140,6 +144,8 @@ CONFIG_PL330_DMA=y
 CONFIG_COMMON_CLK_MAX77686=y
 CONFIG_COMMON_CLK_S2MPS11=y
 CONFIG_EXYNOS_IOMMU=y
+CONFIG_EXTCON=y
+CONFIG_EXTCON_MAX14577=y
 CONFIG_IIO=y
 CONFIG_EXYNOS_ADC=y
 CONFIG_PWM=y
-- 
1.9.1

