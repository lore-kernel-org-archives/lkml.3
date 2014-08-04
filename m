Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaHDATU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 20:19:20 -0400
Received: from s87.loopia.se ([194.9.94.112]:29935 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074AbaHDATQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 20:19:16 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 05/19] media: s5p-mfs: fix %d confusingly prefixed with 0x in format string
Date: Sun,  3 Aug 2014 17:19:01 -0700
Message-Id: <1407111541-14662-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
index c1c12f8..e9175ab 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_opr_v6.c
@@ -525,7 +525,7 @@ static int s5p_mfc_set_enc_stream_buffer_v6(struct s5p_mfc_ctx *ctx,
 	WRITEL(addr, mfc_regs->e_stream_buffer_addr); /* 16B align */
 	WRITEL(size, mfc_regs->e_stream_buffer_size);
 
-	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%d\n",
+	mfc_debug(2, "stream buf addr: 0x%08lx, size: 0x%x\n",
 		  addr, size);
 
 	return 0;
-- 
2.0.0.526.g5318336

