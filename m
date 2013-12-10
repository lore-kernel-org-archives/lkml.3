Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3LJIkx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:40:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58385 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab3LJH7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:59:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH 3.4 18/25] ahci: Add Device IDs for Intel Lynx Point-LP PCH
Date: Tue, 10 Dec 2013 00:00:26 -0800
Message-Id: <20131210075932.104802737@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075930.808460227@linuxfoundation.org>
References: <20131210075930.808460227@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit 77b12bc9cf7b10c7c1a04ca45272fbb4287902d0 upstream.

This patch adds the AHCI-mode SATA Device IDs for the Intel Lynx Point-LP PCH

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -268,6 +268,14 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x8c07), board_ahci }, /* Lynx Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c0e), board_ahci }, /* Lynx Point RAID */
 	{ PCI_VDEVICE(INTEL, 0x8c0f), board_ahci }, /* Lynx Point RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c02), board_ahci }, /* Lynx Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c03), board_ahci }, /* Lynx Point-LP AHCI */
+	{ PCI_VDEVICE(INTEL, 0x9c04), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c05), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c06), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c07), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c0e), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x9c0f), board_ahci }, /* Lynx Point-LP RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


