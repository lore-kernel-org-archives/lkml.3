Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297Ab3G2PVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:21:21 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:48691 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751445Ab3G2PVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:21:20 -0400
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>, tj@kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Subject: [PATCH] ATA: sata_mv: Remove unneeded forward declaration
Date: Mon, 29 Jul 2013 12:21:21 -0300
Message-Id: <1375111282-22624-1-git-send-email-ezequiel.garcia@free-electrons.com>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These forward declarations are no longer needed, and are probably
historical left-over.

Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 drivers/ata/sata_mv.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 35c6b6d..10ea99a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4428,9 +4428,6 @@ static int mv_pci_device_resume(struct pci_dev *pdev)
 #endif
 #endif
 
-static int mv_platform_probe(struct platform_device *pdev);
-static int mv_platform_remove(struct platform_device *pdev);
-
 static int __init mv_init(void)
 {
 	int rc = -ENODEV;
-- 
1.8.1.5

