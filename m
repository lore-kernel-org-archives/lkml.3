Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBISsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:48:35 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62412 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaBISs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:27 -0500
From: Richard Weinberger <richard@nod.at>
To: Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org (open list:IOMMU DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 04/28] Remove EXYNOS_DEV_SYSMMU
Date: Sun,  9 Feb 2014 19:47:42 +0100
Message-Id: <1391971686-9517-5-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/iommu/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 79bbc21..20d062d 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -178,7 +178,7 @@ config TEGRA_IOMMU_SMMU
 
 config EXYNOS_IOMMU
 	bool "Exynos IOMMU Support"
-	depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
+	depends on ARCH_EXYNOS
 	select IOMMU_API
 	help
 	  Support for the IOMMU(System MMU) of Samsung Exynos application
-- 
1.8.4.2

