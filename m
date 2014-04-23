Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbaDWOdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:33:35 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51068 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaDWObt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:31:49 -0400
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, robh+dt@kernel.org, gregkh@linuxfoundation.org,
        olof@lixom.net, balbi@ti.com, jg1.han@samsung.com, t.figa@samsung.com
Subject: [PATCH v5 9/9] ARM: exynos_defconfig: Remove SAMSUNG_USB3PHY config
Date: Wed, 23 Apr 2014 20:00:51 +0530
Message-Id: <1398263451-18023-10-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com>
References: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After removing the phy-samsung-usb3 driver, this config
should be removed.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 arch/arm/configs/exynos_defconfig |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
index 4ce7b70..22cfc75 100644
--- a/arch/arm/configs/exynos_defconfig
+++ b/arch/arm/configs/exynos_defconfig
@@ -99,7 +99,6 @@ CONFIG_USB_STORAGE=y
 CONFIG_USB_DWC3=y
 CONFIG_USB_PHY=y
 CONFIG_SAMSUNG_USB2PHY=y
-CONFIG_SAMSUNG_USB3PHY=y
 CONFIG_MMC=y
 CONFIG_MMC_SDHCI=y
 CONFIG_MMC_SDHCI_S3C=y
-- 
1.7.10.4

