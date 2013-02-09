Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760504Ab3BIBfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:35:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:22770 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758652Ab3BIBfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:35:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,632,1355126400"; 
   d="scan'208";a="260094779"
From: James Ralston <james.d.ralston@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>
Subject: [PATCH 5/5] ahci: Add Device IDs for Intel Wellsburg PCH
Date: Fri,  8 Feb 2013 17:34:47 -0800
Message-Id: <1360373687-2127-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the AHCI-mode SATA Device IDs for the Intel Wellsburg PCH

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 drivers/ata/ahci.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4979127..6aac3f7 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -265,6 +265,14 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x9c07), board_ahci }, /* Lynx Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c0e), board_ahci }, /* Lynx Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c0f), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d02), board_ahci }, /* Wellsburg AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8d04), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d06), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d0e), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d62), board_ahci }, /* Wellsburg AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8d64), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d66), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d6e), board_ahci }, /* Wellsburg RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-- 
1.7.7.6

