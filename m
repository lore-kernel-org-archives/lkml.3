Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaFWMLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:11:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:35399 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbaFWMLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:11:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="551977509"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Alexander Usyskin <alexander.usyskin@intel.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 3/3 V2] mei: add WPT second mei interface
Date: Mon, 23 Jun 2014 15:10:37 +0300
Message-Id: <1403525437-4745-4-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403525437-4745-1-git-send-email-tomas.winkler@intel.com>
References: <1403525437-4745-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Usyskin <alexander.usyskin@intel.com>

Add WPT second mei interface.

Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
V2: use default pch configuration
 drivers/misc/mei/hw-me-regs.h | 1 +
 drivers/misc/mei/pci-me.c     | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/misc/mei/hw-me-regs.h b/drivers/misc/mei/hw-me-regs.h
index a7856c0..c5feafd 100644
--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -115,6 +115,7 @@
 #define MEI_DEV_ID_LPT_HR     0x8CBA  /* Lynx Point H Refresh */
 
 #define MEI_DEV_ID_WPT_LP     0x9CBA  /* Wildcat Point LP */
+#define MEI_DEV_ID_WPT_LP_2   0x9CBB  /* Wildcat Point LP 2 */
 
 /* Host Firmware Status Registers in PCI Config Space */
 #define PCI_CFG_HFS_1         0x40
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 887ace1..f0da3c9 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -81,6 +81,7 @@ static const struct pci_device_id mei_me_pci_tbl[] = {
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_LP, mei_me_pch_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LPT_HR, mei_me_lpt_cfg)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP, mei_me_pch_cfg)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_WPT_LP_2, mei_me_pch_cfg)},
 
 	/* required last entry */
 	{0, }
-- 
1.9.3

