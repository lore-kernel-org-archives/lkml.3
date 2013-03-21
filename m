Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3CULjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:39:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:18434 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab3CULjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:39:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,884,1355126400"; 
   d="scan'208";a="306340343"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dw_dmac: fix typo in Kconfig
Date: Thu, 21 Mar 2013 13:38:55 +0200
Message-Id: <1363865935-2102-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit c30f46bc (drivers/Kconfig: add several missing GENERIC_HARDIRQS
dependencies) introduced a warning on make defconfig stage.  This patch fixes a
typo.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index f641f57..23606b4 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -83,7 +83,7 @@ config INTEL_IOP_ADMA
 
 config DW_DMAC
 	tristate "Synopsys DesignWare AHB DMA support"
-	depends on GENERIQ_HARDIRQS
+	depends on GENERIC_HARDIRQS
 	select DMA_ENGINE
 	default y if CPU_AT32AP7000
 	help
-- 
1.8.2.rc0.22.gb3600c3

