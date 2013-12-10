Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab3LJIkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:40:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3LJH7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:59:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH 3.4 19/25] ahci: AHCI-mode SATA patch for Intel Avoton DeviceIDs
Date: Tue, 10 Dec 2013 00:00:27 -0800
Message-Id: <20131210075932.171454617@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210075930.808460227@linuxfoundation.org>
References: <20131210075930.808460227@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 29e674dd5c8e781589f09c3ee139c80f6da274e4 upstream.

This patch adds the AHCI and RAID-mode SATA DeviceIDs for the Intel Avoton SOC.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -276,6 +276,22 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x9c07), board_ahci }, /* Lynx Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c0e), board_ahci }, /* Lynx Point-LP RAID */
 	{ PCI_VDEVICE(INTEL, 0x9c0f), board_ahci }, /* Lynx Point-LP RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f22), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f23), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f24), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f25), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f26), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f27), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f2e), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f2f), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f32), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f33), board_ahci }, /* Avoton AHCI */
+	{ PCI_VDEVICE(INTEL, 0x1f34), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f35), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f36), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f37), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f3e), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x1f3f), board_ahci }, /* Avoton RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


