Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaK0Iqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:41220 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbaK0Iq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:29 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, James Ralston <james.d.ralston@intel.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 14/91] ahci: Add Device IDs for Intel 9 Series PCH
Date: Thu, 27 Nov 2014 16:41:57 +0800
Message-Id: <1417077794-9299-14-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Ralston <james.d.ralston@intel.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 1b071a0947dbce5c184c12262e02540fbc493457 upstream.

This patch adds the AHCI mode SATA Device IDs for the Intel 9 Series PCH.

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/ata/ahci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 0a450eb..009a097 100644
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
1.9.1

