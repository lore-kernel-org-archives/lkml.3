Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3KLTHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:07:51 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:44242 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab3KLTHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:07:37 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Olof Johansson <olof@lixom.net>, linux-mtd@lists.infradead.org
Subject: [PATCH 03/12] mtd: pasemi_nand.c: Remove superfluous name cast
Date: Tue, 12 Nov 2013 20:07:16 +0100
Message-Id: <1384283245-9419-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Olof Johansson <olof@lixom.net>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/nand/pasemi_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index 4d174366a0f0..90f871acb0ef 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -223,7 +223,7 @@ MODULE_DEVICE_TABLE(of, pasemi_nand_match);
 static struct platform_driver pasemi_nand_driver =
 {
 	.driver = {
-		.name = (char*)driver_name,
+		.name = driver_name,
 		.owner = THIS_MODULE,
 		.of_match_table = pasemi_nand_match,
 	},
-- 
1.7.9.5

