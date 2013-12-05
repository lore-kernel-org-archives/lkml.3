Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab3LERnm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:43:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38420 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab3LERiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Samir Benmendil <samir.benmendil@gmail.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 77/90] ahci: add Marvell 9230 to the AHCI PCI device list
Date: Thu,  5 Dec 2013 17:35:59 +0000
Message-Id: <1386264972-5399-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samir Benmendil <samir.benmendil@gmail.com>

commit 6d5278a68a75891db1df5ae1ecf83d288fc58c65 upstream.

Tested with a DAWICONTROL DC-624e on 3.10.10

Signed-off-by: Samir Benmendil <samir.benmendil@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Levente Kurusa <levex@linux.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index d0f8a93..77795cf 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -439,6 +439,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL_EXT, 0x9230),
+	  .driver_data = board_ahci_yes_fbs },
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
-- 
1.8.3.2

