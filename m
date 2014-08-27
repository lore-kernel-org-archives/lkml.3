Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935874AbaH0V3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:29:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:61549 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932146AbaH0V3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:29:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,414,1406617200"; 
   d="scan'208";a="594217497"
From: James Ralston <james.d.ralston@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: James Ralston <james.d.ralston@intel.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ahci: Add Device IDs for Intel 9 Series PCH
Date: Wed, 27 Aug 2014 14:29:07 -0700
Message-Id: <1409174947-4684-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the AHCI mode SATA Device IDs for the Intel 9 Series PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 drivers/ata/ahci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a29f801..bca3d64 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -305,6 +305,14 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x9c85), board_ahci }, /* Wildcat Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c87), board_ahci }, /* Wildcat Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c8f), board_ahci }, /* Wildcat Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c82), board_ahci }, /* 9 Series AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8c83), board_ahci }, /* 9 Series AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8c84), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c85), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c86), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c87), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c8e), board_ahci }, /* 9 Series RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c8f), board_ahci }, /* 9 Series RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-- 
1.8.3.1

