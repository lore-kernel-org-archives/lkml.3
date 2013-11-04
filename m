Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab3KDRbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:31:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:54115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751526Ab3KDRbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:31:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="403445681"
From: James Ralston <james.d.ralston@intel.com>
To: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>
Subject: [PATCH 4/4] lpc_ich: Add Device IDs for Intel Wildcat Point-LP PCH
Date: Mon,  4 Nov 2013 09:31:20 -0800
Message-Id: <1383586280-4765-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the TCO Watchdog Device IDs for the Intel Wildcat Point-LP PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 drivers/mfd/lpc_ich.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 9483bc8..e775bfb 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -53,6 +53,7 @@
  *	document number TBD : Wellsburg
  *	document number TBD : Avoton SoC
  *	document number TBD : Coleto Creek
+ *	document number TBD : Wildcat Point-LP
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -211,6 +212,7 @@ enum lpc_chipsets {
 	LPC_WBG,	/* Wellsburg */
 	LPC_AVN,	/* Avoton SoC */
 	LPC_COLETO,	/* Coleto Creek */
+	LPC_WPT_LP,	/* Wildcat Point-LP */
 };
 
 static struct lpc_ich_info lpc_chipset_info[] = {
@@ -503,6 +505,10 @@ static struct lpc_ich_info lpc_chipset_info[] = {
 		.name = "Coleto Creek",
 		.iTCO_version = 2,
 	},
+	[LPC_WPT_LP] = {
+		.name = "Lynx Point_LP",
+		.iTCO_version = 2,
+	},
 };
 
 /*
@@ -721,6 +727,13 @@ static DEFINE_PCI_DEVICE_TABLE(lpc_ich_ids) = {
 	{ PCI_VDEVICE(INTEL, 0x1f3a), LPC_AVN},
 	{ PCI_VDEVICE(INTEL, 0x1f3b), LPC_AVN},
 	{ PCI_VDEVICE(INTEL, 0x2390), LPC_COLETO},
+	{ PCI_VDEVICE(INTEL, 0x9cc1), LPC_WPT_LP},
+	{ PCI_VDEVICE(INTEL, 0x9cc2), LPC_WPT_LP},
+	{ PCI_VDEVICE(INTEL, 0x9cc3), LPC_WPT_LP},
+	{ PCI_VDEVICE(INTEL, 0x9cc5), LPC_WPT_LP},
+	{ PCI_VDEVICE(INTEL, 0x9cc6), LPC_WPT_LP},
+	{ PCI_VDEVICE(INTEL, 0x9cc7), LPC_WPT_LP},
+	{ PCI_VDEVICE(INTEL, 0x9cc9), LPC_WPT_LP},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
-- 
1.8.3.1

