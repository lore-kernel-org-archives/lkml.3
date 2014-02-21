Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933145AbaBUNCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:02:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47687 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076AbaBUNCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 08:02:05 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: George Spelvin <linux@horizon.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 23/60] ahci: add an observed PCI ID for Marvell 88se9172 SATA controller
Date: Fri, 21 Feb 2014 13:00:50 +0000
Message-Id: <1392987687-15367-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
References: <1392987687-15367-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.31 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Spelvin <linux@horizon.com>

commit fcce9a35f8faaa1f52236c554ef1b15d99a7537e upstream.

A third possible PCI ID, as personally observed, and found in the
pci.ids list.

Signed-off-by: George Spelvin <linux@horizon.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 0afabef..5630e99 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -435,6 +435,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9172),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9192),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
-- 
1.9.0

