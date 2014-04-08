Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbaDHRT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 13:19:59 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56605 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295AbaDHRT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 13:19:58 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Poggi?= <poggi.raph@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        =?UTF-8?q?Rapha=C3=ABl=20Poggi?= <poggi.raph@gmail.com>
Subject: [PATCH] mtd: nand: add line feed to pr_err
Date: Tue,  8 Apr 2014 10:19:48 -0700
Message-Id: <1396977588-49131-1-git-send-email-poggi.raph@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add line feed to pr_err.

Signed-off-by: Raphaël Poggi <poggi.raph@gmail.com>
---
 drivers/mtd/nand/nand_ecc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/nand_ecc.c b/drivers/mtd/nand/nand_ecc.c
index 053c9a2..97c4c02 100644
--- a/drivers/mtd/nand/nand_ecc.c
+++ b/drivers/mtd/nand/nand_ecc.c
@@ -506,7 +506,7 @@ int __nand_correct_data(unsigned char *buf,
 	if ((bitsperbyte[b0] + bitsperbyte[b1] + bitsperbyte[b2]) == 1)
 		return 1;	/* error in ECC data; no action needed */
 
-	pr_err("%s: uncorrectable ECC error", __func__);
+	pr_err("%s: uncorrectable ECC error\n", __func__);
 	return -1;
 }
 EXPORT_SYMBOL(__nand_correct_data);
-- 
1.8.3.2

