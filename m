Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3JaMzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 08:55:14 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:41313 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab3JaMzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 08:55:12 -0400
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 2/2] mm: fix the comment in zlc_setup()
Date: Thu, 31 Oct 2013 20:52:33 +0800
Message-Id: <1383223953-28803-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1383223953-28803-1-git-send-email-zwu.kernel@gmail.com>
References: <1383223953-28803-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13103112-7182-0000-0000-000008F596C9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index dd886fa..3d94d0c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1711,7 +1711,7 @@ bool zone_watermark_ok_safe(struct zone *z, int order, unsigned long mark,
  * comments in mmzone.h.  Reduces cache footprint of zonelist scans
  * that have to skip over a lot of full or unallowed zones.
  *
- * If the zonelist cache is present in the passed in zonelist, then
+ * If the zonelist cache is present in the passed zonelist, then
  * returns a pointer to the allowed node mask (either the current
  * tasks mems_allowed, or node_states[N_MEMORY].)
  *
-- 
1.7.11.7

