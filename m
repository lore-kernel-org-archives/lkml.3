Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab3AYS7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 13:59:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:25572 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab3AYS7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 13:59:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,540,1355126400"; 
   d="scan'208";a="276701275"
From: Seth Heasley <seth.heasley@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Seth Heasley <seth.heasley@intel.com>,
        James Ralston <james.d.ralston@intel.com>
Subject: [PATCH 1/3] ata_piix: IDE-mode SATA patch for Intel Avoton DeviceIDs
Date: Fri, 25 Jan 2013 11:57:05 -0800
Message-Id: <1359143825-3255-1-git-send-email-seth.heasley@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the IDE-mode SATA DeviceIDs for the Intel Avoton SOC.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 drivers/ata/ata_piix.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 174eca6..651fa85 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -317,6 +317,14 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x9c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (DH89xxCC) */
 	{ 0x8086, 0x2326, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f30, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Avoton) */
+	{ 0x8086, 0x1f31, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
-- 
1.7.11.7

