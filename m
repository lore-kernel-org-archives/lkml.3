Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965169AbaH1IDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 04:03:33 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:64649 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936353AbaH1ICm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 04:02:42 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        kishon@ti.com, kgene.kim@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: [PATCH 4/5] usb: dwc3: Adding Kconfig dependency for Exynos7
Date: Thu, 28 Aug 2014 13:31:59 +0530
Message-Id: <1409212920-28526-5-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
References: <1409212920-28526-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Exynos-DWC3 USB 3.0 DRD controller is also present on
Exynos7 platform, so adding the dependency on ARCH_EXYNOS7
for this driver.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/Kconfig b/drivers/usb/dwc3/Kconfig
index 785510a..e235894 100644
--- a/drivers/usb/dwc3/Kconfig
+++ b/drivers/usb/dwc3/Kconfig
@@ -55,7 +55,7 @@ config USB_DWC3_OMAP
 
 config USB_DWC3_EXYNOS
 	tristate "Samsung Exynos Platform"
-	depends on ARCH_EXYNOS || COMPILE_TEST
+	depends on (ARCH_EXYNOS || ARCH_EXYNOS7) || COMPILE_TEST
 	default USB_DWC3
 	help
 	  Recent Exynos5 SoCs ship with one DesignWare Core USB3 IP inside,
-- 
1.7.10.4

