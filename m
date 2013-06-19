Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935401Ab3FSX0l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:26:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:12553 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934444Ab3FSX0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,900,1363158000"; 
   d="scan'208";a="356446849"
From: Seth Heasley <seth.heasley@intel.com>
To: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: James Ralston <james.d.ralston@intel.com>,
        Seth Heasley <seth.heasley@intel.com>
Subject: [PATCH 1/4] ata_piix: IDE-mode SATA patch for Intel Coleto Creek DeviceIDs
Date: Wed, 19 Jun 2013 16:25:37 -0700
Message-Id: <1371684337-6341-1-git-send-email-seth.heasley@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the IDE-mode SATA DeviceIDs for the Intel Coleto Creek PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
---
 drivers/ata/ata_piix.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9a8a674..8eae659 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -338,6 +338,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (BayTrail) */
 	{ 0x8086, 0x0F20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
 	{ 0x8086, 0x0F21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_byt },
+	/* SATA Controller IDE (Coleto Creek) */
+	{ 0x8086, 0x23a6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 
 	{ }	/* terminate list */
 };
-- 
1.7.4.4

