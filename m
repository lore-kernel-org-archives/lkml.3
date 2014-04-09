Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934141AbaDIQ2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:28:19 -0400
Received: from relay03.alfahosting-server.de ([109.237.142.239]:53931 "EHLO
	relay03.alfahosting-server.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933143AbaDIQ2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:28:15 -0400
X-Spam-DCC: : 
From: Richard Leitner <me@g0hl1n.net>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Richard Leitner <me@g0hl1n.net>
Subject: [PATCH] staging: comedi: adl_pci9118: fix whitespace issues
Date: Wed,  9 Apr 2014 18:27:13 +0200
Message-Id: <1397060833-17925-1-git-send-email-me@g0hl1n.net>
X-Mailer: git-send-email 1.9.1
X-Virus-Checker-Version: clamassassin 1.2.4 with ClamAV 0.97.3/18764/Wed Apr  9 15:10:11 2014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed not needed spaces and fixed too long lines

Signed-off-by: Richard Leitner <me@g0hl1n.net>
---
 drivers/staging/comedi/drivers/adl_pci9118.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 3cfa175..b6abef6 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -96,7 +96,7 @@ Configuration options:
 				 * correct channel number on every 12 bit sample
 				 */
 
-#define IORANGE_9118 	64	/* I hope */
+#define IORANGE_9118	64	/* I hope */
 #define PCI9118_CHANLEN	255	/*
 				 * len of chanlist, some source say 256,
 				 * but reality looks like 255 :-(
@@ -383,7 +383,7 @@ struct pci9118_private {
 						 * users(0-AI, 1-AO, 2-DI, 3-DO)
 						 */
 	unsigned int cnt0_divisor;		/* actual CNT0 divisor */
-	void (*int_ai_func) (struct comedi_device *, struct comedi_subdevice *,
+	void (*int_ai_func)(struct comedi_device *, struct comedi_subdevice *,
 		unsigned short,
 		unsigned int,
 		unsigned short);	/*
@@ -1045,7 +1045,7 @@ static void interrupt_pci9118_ai_dma(struct comedi_device *dev,
 		move_block_from_dma(dev, s,
 				    devpriv->dmabuf_virt[devpriv->dma_actbuf],
 				    samplesinbuf);
-		m = m - sampls;		/* m= how many samples was transferred */
+		m = m - sampls;		/* m=how many samples was transferred */
 	}
 
 	if (!devpriv->ai_neverending) {
-- 
1.9.1

