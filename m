Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490Ab3BIBea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:34:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:12935 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754407Ab3BIBe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:34:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,632,1355126400"; 
   d="scan'208";a="260094625"
From: James Ralston <james.d.ralston@intel.com>
To: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>
Subject: [PATCH 4/5] lpc_ich: Add Device IDs for Intel Wellsburg PCH
Date: Fri,  8 Feb 2013 17:33:38 -0800
Message-Id: <1360373618-2091-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the Watchdog Timer Device IDs for the Intel Wellsburg PCH

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 drivers/mfd/lpc_ich.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index d9d9303..c532a6f 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -50,6 +50,7 @@
  *	document number TBD : Panther Point
  *	document number TBD : Lynx Point
  *	document number TBD : Lynx Point-LP
+ *	document number TBD : Wellsburg
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -194,6 +195,7 @@ enum lpc_chipsets {
 	LPC_PPT,	/* Panther Point */
 	LPC_LPT,	/* Lynx Point */
 	LPC_LPT_LP,	/* Lynx Point-LP */
+	LPC_WBG,	/* Wellsburg */
 };
 
 struct lpc_ich_info lpc_chipset_info[] = {
@@ -474,6 +476,10 @@ struct lpc_ich_info lpc_chipset_info[] = {
 		.name = "Lynx Point_LP",
 		.iTCO_version = 2,
 	},
+	[LPC_WBG] = {
+		.name = "Wellsburg",
+		.iTCO_version = 2,
+	},
 };
 
 /*
@@ -655,6 +661,38 @@ static DEFINE_PCI_DEVICE_TABLE(lpc_ich_ids) = {
 	{ PCI_VDEVICE(INTEL, 0x9c45), LPC_LPT_LP},
 	{ PCI_VDEVICE(INTEL, 0x9c46), LPC_LPT_LP},
 	{ PCI_VDEVICE(INTEL, 0x9c47), LPC_LPT_LP},
+	{ PCI_VDEVICE(INTEL, 0x8d40), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d41), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d42), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d43), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d44), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d45), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d46), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d47), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d48), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d49), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d4a), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d4b), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d4c), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d4d), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d4e), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d4f), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d50), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d51), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d52), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d53), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d54), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d55), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d56), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d57), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d58), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d59), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d5a), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d5b), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d5c), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d5d), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d5e), LPC_WBG},
+	{ PCI_VDEVICE(INTEL, 0x8d5f), LPC_WBG},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
-- 
1.7.7.6

