Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaBISsi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:48:38 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:62415 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaBISsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:48:32 -0500
From: Richard Weinberger <richard@nod.at>
To: Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org (open list:IOMMU DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Cc: Richard Weinberger <richard@nod.at>
Subject: [PATCH 10/28] Remove SH_MOBILE
Date: Sun,  9 Feb 2014 19:47:48 +0100
Message-Id: <1391971686-9517-11-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/iommu/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 20d062d..68b047a 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -206,8 +206,7 @@ config SHMOBILE_IPMMU_TLB
 config SHMOBILE_IOMMU
 	bool "IOMMU for Renesas IPMMU/IPMMUI"
 	default n
-	depends on ARM
-	depends on SH_MOBILE || COMPILE_TEST
+	depends on ARM || COMPILE_TEST
 	select IOMMU_API
 	select ARM_DMA_USE_IOMMU
 	select SHMOBILE_IPMMU
-- 
1.8.4.2

