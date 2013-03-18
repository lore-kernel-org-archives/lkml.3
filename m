Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab3CREhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:37:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33656 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460Ab3CREbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:31:08 -0400
Message-Id: <20130318042147.429728904@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:16 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Seth Heasley <seth.heasley@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 32/82] ahci: AHCI-mode SATA patch for Intel Lynx Point DeviceIDs
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit ea4ace66782fc35245133d2766f38d62827761cc upstream.

This patch adds the AHCI-mode SATA DeviceIDs for the Intel Lynx Point PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -262,6 +262,14 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x1e06), board_ahci }, /* Panther Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x1e07), board_ahci }, /* Panther Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x1e0e), board_ahci }, /* Panther Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c02), board_ahci }, /* Lynx Point AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8c03), board_ahci }, /* Lynx Point AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8c04), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c05), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c06), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c07), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c0e), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x8c0f), board_ahci }, /* Lynx Point RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


