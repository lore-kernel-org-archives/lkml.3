Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758363Ab3KHWAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 17:00:11 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:3903 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792Ab3KHWAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 17:00:07 -0500
Date: Fri, 8 Nov 2013 16:00:04 -0600
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>, thenzl@redhat.com
Subject: [PATCH 1/1] scsi: hpsa correct gen9 PCI IDs
Message-ID: <20131108220004.GA8532@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Miller <mike.miller@hp.com>

This patch deletes one ID that never should have in in hpsa. It also the PCI
ID's for two cancelled products.
Please consider this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/scsi/hpsa.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 891c86b..5ddf749 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -91,21 +91,18 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3249},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324A},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x324B},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSE,     0x103C, 0x3233},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x334D},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3350},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3351},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3352},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3353},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x334D},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1920},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1924},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1925},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1929},
@@ -140,11 +137,11 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324A103C, "Smart Array P712m", &SA5_access},
 	{0x324B103C, "Smart Array P711m", &SA5_access},
+	{0x334D103C, "Smart Array P822se", &SA5_access},
 	{0x3350103C, "Smart Array P222", &SA5_access},
 	{0x3351103C, "Smart Array P420", &SA5_access},
 	{0x3352103C, "Smart Array P421", &SA5_access},
 	{0x3353103C, "Smart Array P822", &SA5_access},
-	{0x334D103C, "Smart Array P822se", &SA5_access},
 	{0x3354103C, "Smart Array P420i", &SA5_access},
 	{0x3355103C, "Smart Array P220i", &SA5_access},
 	{0x3356103C, "Smart Array P721m", &SA5_access},
