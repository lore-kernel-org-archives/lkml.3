Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637AbaIZJwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:52:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755109AbaIZJqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:52 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Tejun Heo <tj@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 139/142] ahci: add pcid for Marvel 0x9182 controller
Date: Fri, 26 Sep 2014 11:45:50 +0200
Message-Id: <be11da6655a9327fb5ee243861773718ec155535.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c5edfff9db6f4d2c35c802acb4abe0df178becee upstream.

Keystone K2E EVM uses Marvel 0x9182 controller. This requires support
for the ID in the ahci driver.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7edbd1e41164..a875de67fb7c 100644
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
2.1.0

