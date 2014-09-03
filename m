Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbaICLUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:20:34 -0400
Received: from syn.loicp.eu ([176.31.96.212]:44664 "EHLO mx0.loicp.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbaICLU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:20:29 -0400
From: Loic Pefferkorn <loic@loicp.eu>
To: gregkh@linuxfoundation.org, alan@linux.intel.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] staging: goldfish: remove useless space after a cast
Date: Wed,  3 Sep 2014 13:13:43 +0200
Message-Id: <1409742827-6048-3-git-send-email-loic@loicp.eu>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1409742827-6048-1-git-send-email-loic@loicp.eu>
References: <1409742827-6048-1-git-send-email-loic@loicp.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coding style: remove useless space after a cast

Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
---
 drivers/staging/goldfish/goldfish_nand.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/goldfish/goldfish_nand.c b/drivers/staging/goldfish/goldfish_nand.c
index 092604c..aac8e20 100644
--- a/drivers/staging/goldfish/goldfish_nand.c
+++ b/drivers/staging/goldfish/goldfish_nand.c
@@ -340,7 +340,7 @@ static int goldfish_nand_init_device(struct platform_device *pdev,
 			       result, name_len);
 		return -ENODEV;
 	}
-	((char *) mtd->name)[name_len] = '\0';
+	((char *)mtd->name)[name_len] = '\0';
 
 	/* Setup the MTD structure */
 	mtd->type = MTD_NANDFLASH;
-- 
2.0.4

