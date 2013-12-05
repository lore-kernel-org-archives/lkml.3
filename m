Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3LEHgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 02:36:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:10901 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab3LEHgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 02:36:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,831,1378882800"; 
   d="scan'208";a="445002277"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next] mei: add 9 series PCH mei device ids
Date: Thu,  5 Dec 2013 09:34:44 +0200
Message-Id: <1386228884-30978-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And Lynx Point H Refresh and Wildcat Point LP
device ids.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: remove duplicated  LPT entry

 drivers/misc/mei/hw-me-regs.h | 5 ++++-
 drivers/misc/mei/pci-me.c     | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index 6c0fde5..66f411a 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -109,9 +109,12 @@
 #define MEI_DEV_ID_PPT_2      0x1CBA  /* Panther Point */
 #define MEI_DEV_ID_PPT_3      0x1DBA  /* Panther Point */
 
-#define MEI_DEV_ID_LPT        0x8C3A  /* Lynx Point */
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

