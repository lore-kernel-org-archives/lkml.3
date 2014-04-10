Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935256AbaDJDsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:48:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41231 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935004AbaDJDWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Ralston <james.d.ralston@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 092/134] ahci: Add Device IDs for Intel Wellsburg PCH
Date: Wed,  9 Apr 2014 20:23:28 -0700
Message-Id: <20140410032311.576952797@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Ralston <james.d.ralston@intel.com>

commit 151743fd8dfb02956c5184b5f4f0f42677eb75bc upstream.

This patch adds the AHCI-mode SATA Device IDs for the Intel Wellsburg PCH

Signed-off-by: James Ralston <james.d.ralston@intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -292,6 +292,14 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x1f37), board_ahci }, /* Avoton RAID */
 	{ PCI_VDEVICE(INTEL, 0x1f3e), board_ahci }, /* Avoton RAID */
 	{ PCI_VDEVICE(INTEL, 0x1f3f), board_ahci }, /* Avoton RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d02), board_ahci }, /* Wellsburg AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8d04), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d06), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d0e), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d62), board_ahci }, /* Wellsburg AHCI */
+	{ PCI_VDEVICE(INTEL, 0x8d64), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d66), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x8d6e), board_ahci }, /* Wellsburg RAID */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


