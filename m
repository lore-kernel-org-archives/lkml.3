Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab3CEWRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:17:37 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467Ab3CEWRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:17:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Joerg Roedel <joro@8bytes.org>,
        iommu@lists.linux-foundation.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Tony Lindgren <tony@atomide.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>
Subject: [PATCH 8/9] iommu: OMAP: build only on OMAP2+
Date: Tue,  5 Mar 2013 23:16:48 +0100
Message-Id: <1362521809-22989-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362521809-22989-1-git-send-email-arnd@arndb.de>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:CVl/jn8SwufX/F8c4iA6lmeXlmAM7UOGWMZHE8FvoUc
 zJ4O8dSdcfD1lmkfcHDbpq1tKeFFX+0aH4KGBCnwVwqx3WbdnS
 JhYKgiXcWrVUwzdIeT7LOGZGnNA0onQTpqJ/hTfC1etP3x6bWL
 lcJiWWH8e73QB2fZeDG7e3/oZ4LWuLbOqLewqXUj/dIAj2b0P2
 Bx3xWk13vPQGos0ZxgbkWh6rSaOj73vGVjvhQB2ufRU/iMdmLI
 crOpOxw87B9jqnTzSEJdGn/U/c4lEnTV2bPxmQZ2XO8wP94aVO
 kFsjSXSFcMPFHoVaeVSORDWQvlwUfnEe8yhTwgA7P3zSrt6R/D
 HInc1qJ6GD6b/edf9puQzidLwLhPHYFc3lR3sH1iZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OMAP IOMMU driver intentionally fails to build on OMAP1
platforms, so we should not allow enabling it there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org
Cc: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
---
 drivers/iommu/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 5c514d07..c332fb9 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -130,7 +130,7 @@ config IRQ_REMAP
 # OMAP IOMMU support
 config OMAP_IOMMU
 	bool "OMAP IOMMU Support"
-	depends on ARCH_OMAP
+	depends on ARCH_OMAP2PLUS
 	select IOMMU_API
 
 config OMAP_IOVMM
-- 
1.8.1.2

