Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab3IDUF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 16:05:59 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:18186 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab3IDUF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 16:05:57 -0400
Date: Wed, 4 Sep 2013 15:05:55 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>
Subject: [PATCH 1/4] hpsa: add HP Smart Array Gen9 PCI ID's
Message-ID: <20130904200555.GA28147@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 of 4

From: Mike Miller <mike.miller@hp.com>

This patch adds the PCI ID's for HP Smart Array Gen9 controllers. Please
consider this patch for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/scsi/hpsa.c     |   25 +++++++++++++++++++++++++
 include/linux/pci_ids.h |    1 +
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 7f4f790..ee71153 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -108,6 +108,19 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x334d},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1929},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BD},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BE},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BF},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C0},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C1},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C2},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C3},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C4},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C5},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C7},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C8},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C9},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -143,6 +156,18 @@ static struct board_type products[] = {
 	{0x1926103C, "Smart Array", &SA5_access},
 	{0x1928103C, "Smart Array", &SA5_access},
 	{0x334d103C, "Smart Array P822se", &SA5_access},
+	{0x21BD103C, "Smart Array", &SA5_access},
+	{0x21BE103C, "Smart Array", &SA5_access},
+	{0x21BF103C, "Smart Array", &SA5_access},
+	{0x21C0103C, "Smart Array", &SA5_access},
+	{0x21C1103C, "Smart Array", &SA5_access},
+	{0x21C2103C, "Smart Array", &SA5_access},
+	{0x21C3103C, "Smart Array", &SA5_access},
+	{0x21C4103C, "Smart Array", &SA5_access},
+	{0x21C5103C, "Smart Array", &SA5_access},
+	{0x21C7103C, "Smart Array", &SA5_access},
+	{0x21C8103C, "Smart Array", &SA5_access},
+	{0x21C9103C, "Smart Array", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3bed2e8..2ce3926 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -756,6 +756,7 @@
 #define PCI_DEVICE_ID_HP_CISSE		0x323a
 #define PCI_DEVICE_ID_HP_CISSF		0x323b
 #define PCI_DEVICE_ID_HP_CISSH		0x323c
+#define PCI_DEVICE_ID_HP_CISSI		0x3239
 #define PCI_DEVICE_ID_HP_ZX2_IOC	0x4031
 
 #define PCI_VENDOR_ID_PCTECH		0x1042
