Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaAUPKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 10:10:23 -0500
Received: from michel.telenet-ops.be ([195.130.137.88]:52075 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbaAUPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:10:20 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Subject: [PATCH 1/5] spi: Spelling s/finised/finished/
Date: Tue, 21 Jan 2014 16:10:05 +0100
Message-Id: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
---
 drivers/spi/spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index a86569e1f178..7f77f82bf95e 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -640,7 +640,7 @@ out:
  *
  * Called by SPI drivers using the core transfer_one_message()
  * implementation to notify it that the current interrupt driven
- * transfer has finised and the next one may be scheduled.
+ * transfer has finished and the next one may be scheduled.
  */
 void spi_finalize_current_transfer(struct spi_master *master)
 {
-- 
1.7.9.5

