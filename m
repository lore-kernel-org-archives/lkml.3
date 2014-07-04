Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbaGDJem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:34:42 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35844 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaGDJel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:34:41 -0400
From: Tushar Behera <tushar.b@samsung.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Cc: pullip.cho@samsung.com, shaik.ameer@samsung.com, trblinux@gmail.com
Subject: [PATCH] iommu/exynos: Select ARM_DMA_USE_IOMMU
Date: Fri,  4 Jul 2014 15:01:08 +0530
Message-Id: <1404466268-9512-1-git-send-email-tushar.b@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For IOMMU to use on Exynos platforms, we need to enable ARM_DMA_USE_IOMMU. It
would be better to select it by default when EXYNOS_IOMMU is enabled.

Signed-off-by: Tushar Behera <tushar.b@samsung.com>
---
 drivers/iommu/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index d260605..54f3ad1a 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -180,6 +180,7 @@ config EXYNOS_IOMMU
 	bool "Exynos IOMMU Support"
 	depends on ARCH_EXYNOS
 	select IOMMU_API
+	select ARM_DMA_USE_IOMMU
 	help
 	  Support for the IOMMU (System MMU) of Samsung Exynos application
 	  processor family. This enables H/W multimedia accelerators to see
-- 
1.7.9.5

