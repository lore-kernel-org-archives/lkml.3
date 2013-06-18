Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab3FRDcg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 23:32:36 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:62527 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3FRDcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 23:32:33 -0400
From: Chad Williamson <chad@dahc.us>
To: gregkh@linuxfoundation.org
Cc: puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Chad Williamson <chad@dahc.us>
Subject: [PATCH 2/4] Staging: silicom: whitespace fixes in bpctl_mod.c
Date: Mon, 17 Jun 2013 22:32:03 -0500
Message-Id: <1371526325-9821-3-git-send-email-chad@dahc.us>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371526325-9821-1-git-send-email-chad@dahc.us>
References: <1371526325-9821-1-git-send-email-chad@dahc.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two trivial whitespace fixes in bpctl_mod.c for the sake of
checkpatch.pl happiness, etc.

Signed-off-by: Chad Williamson <chad@dahc.us>
---
 drivers/staging/silicom/bpctl_mod.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
index c09dc02..893737a 100644
--- a/drivers/staging/silicom/bpctl_mod.c
+++ b/drivers/staging/silicom/bpctl_mod.c
@@ -2028,8 +2028,8 @@ int wdt_off(bpctl_dev_t *pbpctl_dev)
 /* WDT_ON (0x10)*/
 
 /***Global***/
-static unsigned int
-    wdt_val_array[] = { 1000, 1500, 2000, 3000, 4000, 8000, 16000, 32000, 0 };
+static unsigned int wdt_val_array[]
+	= { 1000, 1500, 2000, 3000, 4000, 8000, 16000, 32000, 0 };
 
 int wdt_on(bpctl_dev_t *pbpctl_dev, unsigned int timeout)
 {
@@ -6617,7 +6617,7 @@ static void find_fw(bpctl_dev_t *dev)
 			    ioremap(mmio_start, mmio_len);
 
 			dev->bp_fw_ver = bypass_fw_ver(dev);
-			if (dev-> bp_fw_ver == 0xa8)
+			if (dev->bp_fw_ver == 0xa8)
 				break;
 		}
 	}
-- 
1.8.1.4

