Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab3CDELi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 23:11:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60891 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755851Ab3CDDnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:01 -0500
Message-Id: <20130304033720.376643360@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:17 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Seth Heasley <seth.heasley@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 130/153] ata_piix: IDE-mode SATA patch for Intel Lynx Point DeviceIDs
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 78140cfec503c60a178b11fbaae2fef63e9abdc0 upstream.

This patch adds the IDE-mode SATA DeviceIDs for the Intel Lynx Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ata_piix.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -321,6 +321,14 @@ static const struct pci_device_id piix_p
 	{ 0x8086, 0x1e08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Panther Point) */
 	{ 0x8086, 0x1e09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Lynx Point) */
+	{ 0x8086, 0x8c00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Lynx Point) */
+	{ 0x8086, 0x8c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Lynx Point) */
+	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Lynx Point) */
+	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 


