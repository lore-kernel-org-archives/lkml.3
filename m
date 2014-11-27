Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaK0LFy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:05:54 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:35042 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbaK0LFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:05:52 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Subject: [PATCH/TRIVIAL 3/4] [SCSI] aic7xxx: Grammar s/if ... if/if ... is/
Date: Thu, 27 Nov 2014 12:05:45 +0100
Message-Id: <1417086346-23698-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417086346-23698-1-git-send-email-geert+renesas@glider.be>
References: <1417086346-23698-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 0bcacf71aef814fe..97f2accd3dbb48ac 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -1298,7 +1298,7 @@ rescan_fifos:
 
 	/*
 	 * Wait for any inprogress DMA to complete and clear DMA state
-	 * if this if for an SCB in the qinfifo.
+	 * if this is for an SCB in the qinfifo.
 	 */
 	while (((ccscbctl = ahd_inb(ahd, CCSCBCTL)) & (CCARREN|CCSCBEN)) != 0) {
 
-- 
1.9.1

