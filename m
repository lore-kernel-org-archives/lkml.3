Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965174AbaH0Vej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:34:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:11709 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933809AbaH0Vei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:34:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,414,1406617200"; 
   d="scan'208";a="564394071"
From: James Ralston <james.d.ralston@intel.com>
To: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>
Cc: James Ralston <james.d.ralston@intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] lpc_ich: Add Device IDs for Intel 9 Series PCH
Date: Wed, 27 Aug 2014 14:34:25 -0700
Message-Id: <1409175265-4838-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the LPC Device IDs for the Intel 9 Series PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 drivers/mfd/lpc_ich.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 7d8482f..cb41f4f 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -54,6 +54,7 @@
  *	document number TBD : Avoton SoC
  *	document number TBD : Coleto Creek
  *	document number TBD : Wildcat Point-LP
+ *	document number TBD : 9 Series
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -216,6 +217,7 @@ enum lpc_chipsets {
 	LPC_BAYTRAIL,   /* Bay Trail SoC */
 	LPC_COLETO,	/* Coleto Creek */
 	LPC_WPT_LP,	/* Wildcat Point-LP */
+	LPC_9S,		/* 9 Series */
 };
 
 static struct lpc_ich_info lpc_chipset_info[] = {
@@ -519,6 +521,10 @@ static struct lpc_ich_info lpc_chipset_info[] = {
 		.name = "Wildcat Point_LP",
 		.iTCO_version = 2,
 	},
+	[LPC_9S] = {
+		.name = "9 Series",
+		.iTCO_version = 2,
+	},
 };
 
 /*
@@ -745,6 +751,11 @@ static const struct pci_device_id lpc_ich_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x9cc6), LPC_WPT_LP},
 	{ PCI_VDEVICE(INTEL, 0x9cc7), LPC_WPT_LP},
 	{ PCI_VDEVICE(INTEL, 0x9cc9), LPC_WPT_LP},
+	{ PCI_VDEVICE(INTEL, 0x8cc1), LPC_9S},
+	{ PCI_VDEVICE(INTEL, 0x8cc2), LPC_9S},
+	{ PCI_VDEVICE(INTEL, 0x8cc3), LPC_9S},
+	{ PCI_VDEVICE(INTEL, 0x8cc4), LPC_9S},
+	{ PCI_VDEVICE(INTEL, 0x8cc6), LPC_9S},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
-- 
1.8.3.1

