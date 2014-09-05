Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaIERMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:12:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47408 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaIERMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:12:07 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>, Tejun Heo <tj@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH] ahci: add pcid for Marvel 0x9182 controller
Date: Fri, 5 Sep 2014 13:12:26 -0400
Message-ID: <1409937146-30450-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

CC: Tejun Heo <tj@kernel.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/ata/ahci.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index a29f801..02a415e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -442,6 +442,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9172),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9182 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9182),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9192),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
-- 
1.7.9.5

