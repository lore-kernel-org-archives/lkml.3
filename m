Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaHDASz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:18:55 -0400
Received: from s87.loopia.se ([194.9.94.112]:29802 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbaHDASw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:18:52 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: joe@perches.com, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 03/19] drivers: DAC960 fix %d confusingly prefixed with 0x in format strings
Date: Sun,  3 Aug 2014 17:18:38 -0700
Message-Id: <1407111518-14589-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/block/DAC960.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 811e11c..d9b32f2 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -2954,7 +2954,7 @@ DAC960_DetectController(struct pci_dev *PCI_Device,
 	case DAC960_PD_Controller:
 	  if (!request_region(Controller->IO_Address, 0x80,
 			      Controller->FullModelName)) {
-		DAC960_Error("IO port 0x%d busy for Controller at\n",
+		DAC960_Error("IO port 0x%x busy for Controller at\n",
 			     Controller, Controller->IO_Address);
 		goto Failure;
 	  }
@@ -2990,7 +2990,7 @@ DAC960_DetectController(struct pci_dev *PCI_Device,
 	case DAC960_P_Controller:
 	  if (!request_region(Controller->IO_Address, 0x80,
 			      Controller->FullModelName)){
-		DAC960_Error("IO port 0x%d busy for Controller at\n",
+		DAC960_Error("IO port 0x%x busy for Controller at\n",
 		   	     Controller, Controller->IO_Address);
 		goto Failure;
 	  }
-- 
2.0.0.526.g5318336

