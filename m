Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab3KZSEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:04:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:16592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab3KZSEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:04:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,776,1378882800"; 
   d="scan'208";a="415403328"
From: James Ralston <james.d.ralston@intel.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH 1/1] lpc_ich: Add Device IDs for Intel Wildcat Point-LP PCH
Date: Tue, 26 Nov 2013 10:04:12 -0800
Message-Id: <1385489052-4872-1-git-send-email-james.d.ralston@intel.com>
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
index 9483bc8..019f578 100644
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
+		.name = "Wildcat Point_LP",
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

