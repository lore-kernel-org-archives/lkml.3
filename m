Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbaFWJBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 05:01:17 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55486 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbaFWIc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20Schr=C3=A4gle?= <ajs124.ajs124@gmail.com>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 075/111] ahci: add PCI ID for Marvell 88SE91A0 SATA Controller
Date: Mon, 23 Jun 2014 10:31:50 +0200
Message-Id: <e22c4b0b49a7afb7870817b5a9b508f67c5025a6.1403512281.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Schrägle <ajs124.ajs124@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 754a292fe6b08196cb135c03b404444e17de520a upstream.

Add support for Marvell Technology Group Ltd. 88SE91A0 SATA 6Gb/s
Controller by adding its PCI ID.

Signed-off-by: Andreas Schrägle <ajs124.ajs124@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 65ef4024da09..5421a820ec7d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -444,6 +444,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9192),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a0),
+	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
-- 
2.0.0

