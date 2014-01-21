Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbaAUPQF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:16:05 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:35626 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaAUPQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:16:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <axboe@kernel.dk>, Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH -trivial] mg_disk: Spelling s/finised/finished/
Date: Tue, 21 Jan 2014 16:15:53 +0100
Message-Id: <1390317353-8805-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/block/mg_disk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 7bc363f1ee82..eb59b1241366 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -915,7 +915,7 @@ static int mg_probe(struct platform_device *plat_dev)
 
 	/* disk reset */
 	if (prv_data->dev_attr == MG_STORAGE_DEV) {
-		/* If POR seq. not yet finised, wait */
+		/* If POR seq. not yet finished, wait */
 		err = mg_wait_rstout(host->rstout, MG_TMAX_RSTOUT);
 		if (err)
 			goto probe_err_3b;
-- 
1.7.9.5

