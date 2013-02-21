Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab3BUTJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:09:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:59233 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752231Ab3BUTJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:09:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,711,1355126400"; 
   d="scan'208";a="265830498"
From: James Ralston <james.d.ralston@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>
Subject: [PATCH 1/1] ahci: Add Device IDs for Intel Wellsburg PCH
Date: Thu, 21 Feb 2013 11:08:51 -0800
Message-Id: <1361473731-2266-1-git-send-email-james.d.ralston@intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the RAID-mode SATA Device IDs for the Intel Wellsburg PCH

Signed-off-by: James Ralston <james.d.ralston@intel.com>
---
 drivers/ata/ahci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 4032961..ffac5cf 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -265,6 +265,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x9c07), board_ahci }, /* Lynx Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c0e), board_ahci }, /* Lynx Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c0f), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x2823), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x2827), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d02), board_ahci }, /* Wellsburg AHCI */
 	{ PCI_VDEVICE(INTEL, 0x8d04), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d06), board_ahci }, /* Wellsburg RAID */
-- 
1.7.7.6

