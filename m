Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab3LCLCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:02:52 -0500
Received: from mga02.intel.com ([134.134.136.20]:43479 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181Ab3LCLCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:02:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,817,1378882800"; 
   d="scan'208";a="437669967"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: add 9 series PCH mei device ids
Date: Tue,  3 Dec 2013 13:01:29 +0200
Message-Id: <1386068489-19511-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And Lynx Point H Refresh and Wildcat Point LP
device ids.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me-regs.h | 4 ++++
 drivers/misc/mei/pci-me.c     | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 6c0fde5..f83bc80 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -110,8 +110,12 @@
 #define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
 
 #define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
+#define MEI_DEV_ID_LPT_H      0x8C3A  /* Lynx Point H */
 #define MEI_DEV_ID_LPT_W      0x8D3A  /* Lynx Point - Wellsburg */
 #define MEI_DEV_ID_LPT_LP     0x9C3A  /* Lynx Point LP */
+#define MEI_DEV_ID_LPT_HR     0x8CBA  /* Lynx Point H Refresh */
+
+#define MEI_DEV_ID_WPT_LP     0x9CBA  /* Wildcat Point LP */
 /*
  * MEI HW Section
  */
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 3bfae38..7dfaa32 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -76,9 +76,11 @@ static DEFINE_PCI_DEVICE_TABLE(mei_me_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_1)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_2)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PPT_3)},
-	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_H)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_W)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_LP)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_LPT_HR)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_WPT_LP)},
 
 	/* required last entry */
 	{0, }
-- 
1.8.3.1

