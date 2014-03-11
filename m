Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaCKKbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:31:37 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:43615 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762AbaCKKX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:23:59 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org
Subject: [PATCH trivial 07/16] PM / Hibernate: Spelling s/anonymouns/anonymous/
Date: Tue, 11 Mar 2014 11:23:41 +0100
Message-Id: <1394533430-4746-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
References: <1394533430-4746-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>

Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: linux-pm@vger.kernel.org
---
 kernel/power/snapshot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index d9f61a145802..149e745eaa52 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1268,7 +1268,7 @@ static void free_unnecessary_pages(void)
  * [number of saveable pages] - [number of pages that can be freed in theory]
  *
  * where the second term is the sum of (1) reclaimable slab pages, (2) active
- * and (3) inactive anonymouns pages, (4) active and (5) inactive file pages,
+ * and (3) inactive anonymous pages, (4) active and (5) inactive file pages,
  * minus mapped file pages.
  */
 static unsigned long minimum_image_size(unsigned long saveable)
-- 
1.7.9.5

