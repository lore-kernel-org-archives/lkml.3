Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3DVKgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 06:36:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:27385 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534Ab3DVKgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 06:36:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,525,1363158000"; 
   d="scan'208";a="230231870"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] lib: fix trivial typo in the comment
Date: Mon, 22 Apr 2013 13:36:39 +0300
Message-Id: <1366626999-6270-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes "iff" as "if".

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib/string.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/string.c b/lib/string.c
index e5878de..e551284 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -542,7 +542,7 @@ EXPORT_SYMBOL(sysfs_streq);
  * @s: input string
  * @res: result
  *
- * This routine returns 0 iff the first character is one of 'Yy1Nn0'.
+ * This routine returns 0 if the first character is one of 'Yy1Nn0'.
  * Otherwise it will return -EINVAL.  Value pointed to by res is
  * updated upon finding a match.
  */
-- 
1.8.2.rc0.22.gb3600c3

