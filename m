Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbaJVJts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:49:48 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:37720 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbaJVJs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:48:58 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH/TRIVIAL 3/5] of: Spelling s/stucture/structure/
Date: Wed, 22 Oct 2014 11:49:01 +0200
Message-Id: <1413971343-27554-3-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413971343-27554-1-git-send-email-geert+renesas@glider.be>
References: <1413971343-27554-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
---
 drivers/of/dynamic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/dynamic.c b/drivers/of/dynamic.c
index f297891d852908ae..d4994177dec25506 100644
--- a/drivers/of/dynamic.c
+++ b/drivers/of/dynamic.c
@@ -247,7 +247,7 @@ void of_node_release(struct kobject *kobj)
  * @allocflags:	Allocation flags (typically pass GFP_KERNEL)
  *
  * Copy a property by dynamically allocating the memory of both the
- * property stucture and the property name & contents. The property's
+ * property structure and the property name & contents. The property's
  * flags have the OF_DYNAMIC bit set so that we can differentiate between
  * dynamically allocated properties and not.
  * Returns the newly allocated property or NULL on out of memory error.
-- 
1.9.1

