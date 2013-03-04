Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab3CDDmx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:42:53 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60872 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755524Ab3CDDmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:42:49 -0500
Message-Id: <20130304033720.572774793@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:19 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, James Ralston <james.d.ralston@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 132/153] ata_piix: Add Device IDs for Intel Lynx Point-LP PCH
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit 389cd784969e9148fedcde0608f15bd74d6b769e upstream.

This patch adds the IDE-mode SATA Device IDs for the Intel Lynx Point-LP PCH

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ata_piix.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -329,6 +329,14 @@ static const struct pci_device_id piix_p
 	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Lynx Point-LP) */
+	{ 0x8086, 0x9c00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Lynx Point-LP) */
+	{ 0x8086, 0x9c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
+	/* SATA Controller IDE (Lynx Point-LP) */
+	{ 0x8086, 0x9c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (Lynx Point-LP) */
+	{ 0x8086, 0x9c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (DH89xxCC) */
 	{ 0x8086, 0x2326, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */


