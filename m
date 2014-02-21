Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbaBUNCL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:02:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47671 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858AbaBUNCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Myron Stowe <myron.stowe@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 22/60] ahci: Use PCI_VENDOR_ID_MARVELL_EXT for 0x1b4b
Date: Fri, 21 Feb 2014 13:00:49 +0000
Message-Id: <1392987687-15367-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myron Stowe <myron.stowe@redhat.com>

commit 69fd3157363935b1e052bd76b8f8ec65e494306e upstream.

With the 0x1b4b vendor ID #define in place, convert hard-coded ID
values.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ahci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 77795cf..0afabef 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -427,17 +427,17 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
-	{ PCI_DEVICE(0x1b4b, 0x9123),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9123),
 	  .class = PCI_CLASS_STORAGE_SATA_AHCI,
 	  .class_mask = 0xffffff,
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
-	{ PCI_DEVICE(0x1b4b, 0x9125),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9125),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
-	{ PCI_DEVICE(0x1b4b, 0x917a),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
-	{ PCI_DEVICE(0x1b4b, 0x9192),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9192),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
-	{ PCI_DEVICE(0x1b4b, 0x91a3),
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
 	  .driver_data = board_ahci_yes_fbs },
-- 
1.9.0

