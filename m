Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaJGKUH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:20:07 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:63636 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbaJGKUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:20:00 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        kishon@ti.com, Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH v2 4/4] phy: exynos7-usbdrd: Update dependency for ARCH_EXYNOS
Date: Tue,  7 Oct 2014 15:49:36 +0530
Message-Id: <1412677176-3850-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This PHY controller is also present on Exynos7 platform
in arch-exynos family.
So PHY_EXYNOS5_USBDRD should now depend on ARCH_EXYNOS.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/phy/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 2a436e6..1514e40 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -193,7 +193,7 @@ config PHY_EXYNOS5250_USB2
 
 config PHY_EXYNOS5_USBDRD
 	tristate "Exynos5 SoC series USB DRD PHY driver"
-	depends on ARCH_EXYNOS5 && OF
+	depends on ARCH_EXYNOS && OF
 	depends on HAS_IOMEM
 	depends on USB_DWC3_EXYNOS
 	select GENERIC_PHY
-- 
1.7.10.4

