Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3IZT7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 15:59:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:11780 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab3IZT7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 15:59:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,988,1371106800"; 
   d="scan'208";a="401592438"
From: David Cohen <david.a.cohen@linux.intel.com>
To: balbi@ti.com, gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH] usb: dwc3: add support for Merrifield
Date: Thu, 26 Sep 2013 13:01:44 -0700
Message-Id: <1380225704-28923-1-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PCI id for Intel Merrifield

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/usb/dwc3/dwc3-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 997ebe4..2e252aa 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -29,6 +29,7 @@
 #define PCI_VENDOR_ID_SYNOPSYS		0x16c3
 #define PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3	0xabcd
 #define PCI_DEVICE_ID_INTEL_BYT		0x0f37
+#define PCI_DEVICE_ID_INTEL_MRFLD	0x119e
 
 struct dwc3_pci {
 	struct device		*dev;
@@ -189,6 +190,7 @@ static DEFINE_PCI_DEVICE_TABLE(dwc3_pci_id_table) = {
 				PCI_DEVICE_ID_SYNOPSYS_HAPSUSB3),
 	},
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_BYT), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_MRFLD), },
 	{  }	/* Terminating Entry */
 };
 MODULE_DEVICE_TABLE(pci, dwc3_pci_id_table);
-- 
1.8.4.rc3

