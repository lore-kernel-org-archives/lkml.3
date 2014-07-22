Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249AbaGVW0B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:26:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44727 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933222AbaGVWZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:25:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Andreas=20Schr=C3=A4gle?= <ajs124.ajs124@gmail.com>,
        Tejun Heo <tj@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 031/116] ahci: add PCI ID for Marvell 88SE91A0 SATA Controller
Date: Tue, 22 Jul 2014 15:20:42 -0700
Message-Id: <1406067727-19683-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Andreas=20Schr=C3=A4gle?= <ajs124.ajs124@gmail.com>

commit 754a292fe6b08196cb135c03b404444e17de520a upstream.

Add support for Marvell Technology Group Ltd. 88SE91A0 SATA 6Gb/s
Controller by adding its PCI ID.

Signed-off-by: Andreas Schrägle <ajs124.ajs124@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ kamal: backport to 3.8-stable ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index f0faa0d..c752e6f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -440,6 +440,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(0x1b4b, 0x9192),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
+	{ PCI_DEVICE(0x1b4b, 0x91a0),
+	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 	{ PCI_DEVICE(0x1b4b, 0x9230),
-- 
1.9.1

