Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968AbaJIVkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:40:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59155 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbaJIVID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Murali Karicheri <m-karicheri2@ti.com>, Tejun Heo <tj@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 031/163] ahci: add pcid for Marvel 0x9182 controller
Date: Thu,  9 Oct 2014 14:00:56 -0700
Message-Id: <1412888588-26755-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murali Karicheri <m-karicheri2@ti.com>

commit c5edfff9db6f4d2c35c802acb4abe0df178becee upstream.

Keystone K2E EVM uses Marvel 0x9182 controller. This requires support
for the ID in the ahci driver.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 95c297b..e455090 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -449,6 +449,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9172),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9182 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9182),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9192),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
-- 
1.9.1

