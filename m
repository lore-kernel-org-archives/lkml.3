Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3JBJVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 05:21:48 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:50879 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3JBJVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 05:21:46 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] of/of_reserved_mem.c: fix typo
Date: Wed,  2 Oct 2013 14:48:29 +0530
Message-Id: <1380705509-25429-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/of/of_reserved_mem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 0fe40c7..c7a1ea3 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -54,7 +54,7 @@ static int __init fdt_scan_reserved_mem(unsigned long node, const char *uname,
 
 	status = of_get_flat_dt_prop(node, "status", &len);
 	if (status && strcmp(status, "okay") != 0) {
-		/* ignore disabled node nad scan next one */
+		/* ignore disabled node and scan next one */
 		return 0;
 	}
 
-- 
1.7.9.5

