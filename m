Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaISJtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 05:49:03 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaISJtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 05:49:00 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/2] UBI: Improve comment on work_sem
Date: Fri, 19 Sep 2014 11:48:47 +0200
Message-Id: <1411120127-18787-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1411120127-18787-1-git-send-email-richard@nod.at>
References: <1411120127-18787-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make clear what work_sem really does.

Suggested-by: Artem Bityutskiy <dedekind1@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 7bf4163..f2933df 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -439,7 +439,8 @@ struct ubi_debug_info {
  *	     @move_to, @move_to_put @erase_pending, @wl_scheduled, @works,
  *	     @erroneous, and @erroneous_peb_count fields
  * @move_mutex: serializes eraseblock moves
- * @work_sem: synchronizes the WL worker with use tasks
+ * @work_sem: used to wait for all the scheduled works to finish and prevent
+ * new works from being submitted
  * @wl_scheduled: non-zero if the wear-leveling was scheduled
  * @lookuptbl: a table to quickly find a &struct ubi_wl_entry object for any
  *             physical eraseblock
-- 
1.8.4.5

