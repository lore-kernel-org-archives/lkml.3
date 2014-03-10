Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaCJVfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:35:41 -0400
Received: from xes-mad.com ([216.165.139.218]:62172 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675AbaCJVfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:35:39 -0400
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 8/8] mfd: lpc_ich: Add support for Intel Bay Trail SoC
Date: Mon, 10 Mar 2014 16:34:58 -0500
Message-Id: <1394487298-14459-8-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.7.GIT
In-Reply-To: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the LPC Controller Device IDs for Watchdog and GPIO for
the Intel Bay Trail Atom SoC.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: James Ralston <james.d.ralston@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/lpc_ich.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 82d70f7..6e08ce1 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -214,6 +214,7 @@ enum lpc_chipsets {
 	LPC_LPT_LP,	/* Lynx Point-LP */
 	LPC_WBG,	/* Wellsburg */
 	LPC_AVN,	/* Avoton SoC */
+	LPC_BAYTRAIL,   /* Bay Trail SoC */
 	LPC_COLETO,	/* Coleto Creek */
 	LPC_WPT_LP,	/* Wildcat Point-LP */
 };
@@ -505,6 +506,10 @@ static struct lpc_ich_info lpc_chipset_info[] = {
 		.name = "Avoton SoC",
 		.iTCO_version = 3,
 	},
+	[LPC_BAYTRAIL] = {
+		.name = "Bay Trail SoC",
+		.iTCO_version = 3,
+	},
 	[LPC_COLETO] = {
 		.name = "Coleto Creek",
 		.iTCO_version = 2,
@@ -730,6 +735,7 @@ static const struct pci_device_id lpc_ich_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x1f39), LPC_AVN},
 	{ PCI_VDEVICE(INTEL, 0x1f3a), LPC_AVN},
 	{ PCI_VDEVICE(INTEL, 0x1f3b), LPC_AVN},
+	{ PCI_VDEVICE(INTEL, 0x0f1c), LPC_BAYTRAIL},
 	{ PCI_VDEVICE(INTEL, 0x2390), LPC_COLETO},
 	{ PCI_VDEVICE(INTEL, 0x9cc1), LPC_WPT_LP},
 	{ PCI_VDEVICE(INTEL, 0x9cc2), LPC_WPT_LP},
-- 
1.7.7.GIT

