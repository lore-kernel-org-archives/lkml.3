Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965102AbaDJDrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:47:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41237 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935012AbaDJDWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seth Heasley <seth.heasley@intel.com>, Tejun Heo <tj@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 093/134] ahci: AHCI-mode SATA patch for Intel Coleto Creek DeviceIDs
Date: Wed,  9 Apr 2014 20:23:29 -0700
Message-Id: <20140410032311.683083732@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Heasley <seth.heasley@intel.com>

commit 1cfc7df3de10c40ed459e13cce6de616023bf41c upstream.

This patch adds the AHCI-mode SATA DeviceIDs for the Intel Coleto Creek PCH.

Signed-off-by: Seth Heasley <seth.heasley@intel.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -300,6 +300,7 @@ static const struct pci_device_id ahci_p
 	{ PCI_VDEVICE(INTEL, 0x8d64), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d66), board_ahci }, /* Wellsburg RAID */
 	{ PCI_VDEVICE(INTEL, 0x8d6e), board_ahci }, /* Wellsburg RAID */
+	{ PCI_VDEVICE(INTEL, 0x23a3), board_ahci }, /* Coleto Creek AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


