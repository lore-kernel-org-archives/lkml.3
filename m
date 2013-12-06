Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162546Ab3LFNX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:23:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44550 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161878Ab3LFNEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 209/272] mfd: lpc_ich: Add Device IDs for Intel Wildcat Point-LP PCH
Date: Fri,  6 Dec 2013 12:58:18 +0000
Message-Id: <1386334761-25517-210-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit 5e90169c5a02da69a1ef721bea7a823e9e48fcb6 upstream.

This patch adds the TCO Watchdog Device IDs for the
Intel Wildcat Point-LP PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mfd/lpc_ich.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 2403332..c2ccfc0 100644
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
 
 struct lpc_ich_info lpc_chipset_info[] = {
@@ -503,6 +505,10 @@ struct lpc_ich_info lpc_chipset_info[] = {
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
1.8.3.2

