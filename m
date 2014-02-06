Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360AbaBFL1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:27:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:35340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085AbaBFL07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:26:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,793,1384329600"; 
   d="scan'208";a="476914551"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] dma: dw: add a PCI ID for Intel Haswell SoC
Date: Thu,  6 Feb 2014 13:26:55 +0200
Message-Id: <1391686015-7719-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.9.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case of PCI mode the DMA controller has a specific ID. Put this ID to the
list of supported.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dw/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/dw/pci.c b/drivers/dma/dw/pci.c
index e89fc24..755cc6b 100644
--- a/drivers/dma/dw/pci.c
+++ b/drivers/dma/dw/pci.c
@@ -83,6 +83,9 @@ static DEFINE_PCI_DEVICE_TABLE(dw_pci_id_table) = {
 	/* BayTrail */
 	{ PCI_VDEVICE(INTEL, 0x0f06), (kernel_ulong_t)&dw_pci_pdata },
 	{ PCI_VDEVICE(INTEL, 0x0f40), (kernel_ulong_t)&dw_pci_pdata },
+
+	/* Haswell */
+	{ PCI_VDEVICE(INTEL, 0x9c60), (kernel_ulong_t)&dw_pci_pdata },
 	{ }
 };
 MODULE_DEVICE_TABLE(pci, dw_pci_id_table);
-- 
1.9.rc1

