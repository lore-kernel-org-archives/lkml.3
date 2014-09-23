Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748AbaIWTmD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 15:42:03 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50479 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756646AbaIWTl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 15:41:27 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, tklauser@distanz.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 3/4] staging: et131x: Add space after { in pci ID table
Date: Tue, 23 Sep 2014 20:41:13 +0100
Message-Id: <1411501274-2970-3-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411501274-2970-1-git-send-email-mark.einon@gmail.com>
References: <20140923100106.GE4657@distanz.ch>
 <1411501274-2970-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 6539a8a..10f20b3 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -4397,7 +4397,7 @@ err_disable:
 static const struct pci_device_id et131x_pci_table[] = {
 	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_GIG), 0UL},
 	{ PCI_VDEVICE(ATT, ET131X_PCI_DEVICE_ID_FAST), 0UL},
-	{0,}
+	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, et131x_pci_table);
 
-- 
2.1.0

