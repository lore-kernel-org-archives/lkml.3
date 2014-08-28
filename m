Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936392AbaH1ICx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:02:53 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34325 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936346AbaH1ICo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:02:44 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        kishon@ti.com, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 5/5] phy: exynos5-usbdrd: Adding Kconfig dependency for Exynos7
Date: Thu, 28 Aug 2014 13:32:00 +0530
Message-Id: <1409212920-28526-6-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This USB 3.0 PHY controller is also present on Exynos7
platform, so adding the dependency on ARCH_EXYNOS7 for this driver.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 0dd7427..c3bc380 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -186,7 +186,7 @@ config PHY_EXYNOS5250_USB2
 
 config PHY_EXYNOS5_USBDRD
 	tristate "Exynos5 SoC series USB DRD PHY driver"
-	depends on ARCH_EXYNOS5 && OF
+	depends on (ARCH_EXYNOS5 || ARCH_EXYNOS7) && OF
 	depends on HAS_IOMEM
 	depends on USB_DWC3_EXYNOS
 	select GENERIC_PHY
-- 
1.7.10.4

