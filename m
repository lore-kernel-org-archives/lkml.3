Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbaJVJqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:46:14 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:55720 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677AbaJVJo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:44:58 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/4] of: Improve grammar for of_alias_scan() documentation
Date: Wed, 22 Oct 2014 11:44:53 +0200
Message-Id: <1413971095-27192-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413971095-27192-1-git-send-email-geert+renesas@glider.be>
References: <1413971095-27192-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/of/base.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index e3f9043860c81b5d..48d6673fa9a28bf0 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1849,14 +1849,14 @@ static void of_alias_add(struct alias_prop *ap, struct device_node *np,
 }
 
 /**
- * of_alias_scan - Scan all properties of 'aliases' node
+ * of_alias_scan - Scan all properties of the 'aliases' node
  *
- * The function scans all the properties of 'aliases' node and populate
- * the the global lookup table with the properties.  It returns the
- * number of alias_prop found, or error code in error case.
+ * The function scans all the properties of the 'aliases' node and populates
+ * the global lookup table with the properties.  It returns the
+ * number of alias properties found, or an error code in case of failure.
  *
  * @dt_alloc:	An allocator that provides a virtual address to memory
- *		for the resulting tree
+ *		for storing the resulting tree
  */
 void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 {
-- 
1.9.1

