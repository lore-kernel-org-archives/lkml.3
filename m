Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3CZWmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:42:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:14093 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab3CZWmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,915,1355126400"; 
   d="scan'208";a="276349321"
Subject: [PATCH 01/10] ioatdma: Adding PCI IDs for Intel Atom S1200 product
 family ioatdma devices
To: djbw@fb.com
From: Dave Jiang <dave.jiang@intel.com>
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org
Date: Tue, 26 Mar 2013 15:42:35 -0700
Message-ID: <20130326224235.15072.60222.stgit@djiang5-linux2.ch.intel.com>
In-Reply-To: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
References: <20130326223953.15072.26605.stgit@djiang5-linux2.ch.intel.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These should be good for the IOAT DMA devices on the Intel Atom S1269,
S1279, and S1289 platforms. We are also adding IOAT v3.3 definition for
the new DMA engine.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dma/ioat/hw.h  |    6 ++++++
 drivers/dma/ioat/pci.c |    6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/dma/ioat/hw.h b/drivers/dma/ioat/hw.h
index 8cfa077..ce431f5 100644
--- a/drivers/dma/ioat/hw.h
+++ b/drivers/dma/ioat/hw.h
@@ -52,10 +52,16 @@
 #define PCI_DEVICE_ID_INTEL_IOAT_HSW8	0x2f2e
 #define PCI_DEVICE_ID_INTEL_IOAT_HSW9	0x2f2f
 
+#define PCI_DEVICE_ID_INTEL_IOAT_BWD0	0x0C50
+#define PCI_DEVICE_ID_INTEL_IOAT_BWD1	0x0C51
+#define PCI_DEVICE_ID_INTEL_IOAT_BWD2	0x0C52
+#define PCI_DEVICE_ID_INTEL_IOAT_BWD3	0x0C53
+
 #define IOAT_VER_1_2            0x12    /* Version 1.2 */
 #define IOAT_VER_2_0            0x20    /* Version 2.0 */
 #define IOAT_VER_3_0            0x30    /* Version 3.0 */
 #define IOAT_VER_3_2            0x32    /* Version 3.2 */
+#define IOAT_VER_3_3            0x33    /* Version 3.3 */
 
 
 int system_has_dca_enabled(struct pci_dev *pdev);
diff --git a/drivers/dma/ioat/pci.c b/drivers/dma/ioat/pci.c
index 67c8e83..1f63296 100644
--- a/drivers/dma/ioat/pci.c
+++ b/drivers/dma/ioat/pci.c
@@ -105,6 +105,12 @@ static struct pci_device_id ioat_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW8) },
 	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_HSW9) },
 
+	/* I/OAT v3.3 platforms */
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_BWD0) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_BWD1) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_BWD2) },
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_IOAT_BWD3) },
+
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, ioat_pci_tbl);

