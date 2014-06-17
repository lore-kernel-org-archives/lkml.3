Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408AbaFQTOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 15:14:25 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:9329 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755372AbaFQTOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 15:14:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQJALCQoFNbsl1t/2dsb2JhbABagw2rKgUBAQEBAQEFAZkmgQ0XdYRgI4EaN4hGAcsvF4VjiC9kHYQtBIRjA5VdizCIKINCO4Ex
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@fb.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 3/3] drivers/block/skd_main.c: replace deprecated DEFINE_PCI_DEVICE_TABLE
Date: Tue, 17 Jun 2014 21:13:03 +0200
Message-Id: <1403032383-4995-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: Prefer struct pci_device_id over deprecated DEFINE_PCI_DEVICE_TABLE

Cc: Jens Axboe <axboe@fb.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/block/skd_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/skd_main.c b/drivers/block/skd_main.c
index 1756d26d..3142eef 100644
--- a/drivers/block/skd_main.c
+++ b/drivers/block/skd_main.c
@@ -4772,7 +4772,7 @@ static const struct block_device_operations skd_blockdev_ops = {
  *****************************************************************************
  */
 
-static DEFINE_PCI_DEVICE_TABLE(skd_pci_tbl) = {
+static const struct pci_device_id skd_pci_tbl[] = {
 	{ PCI_VENDOR_ID_STEC, PCI_DEVICE_ID_S1120,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, },
 	{ 0 }                     /* terminate list */
-- 
1.8.4.5

