Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbbAGKQN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 05:16:13 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57192 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbbAGKQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 05:16:10 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-66-54ad076833ee
From: Marcin Jabrzyk <m.jabrzyk@samsung.com>
To: konrad.wilk@oracle.com, trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Marcin Jabrzyk <m.jabrzyk@samsung.com>
Subject: [PATCH] mm: fix cleancache debugfs directory path
Date: Wed, 07 Jan 2015 11:14:41 +0100
Message-id: <1420625681-13819-1-git-send-email-m.jabrzyk@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDJMWRmVeSWpSXmKPExsVy+t/xa7oZ7GtDDGb/V7XYOGM9q8WyxU8Z
	Lc42vWG3uLxrDpvFvTX/WS2mne9mtHi//zKTA7vHplWdbB6bPk1i9/j49BaLR9+WVYwenzfJ
	BbBGcdmkpOZklqUW6dslcGXc77vJWtDOXfHhyn72BsaZnF2MHBwSAiYSN+eIdjFyApliEhfu
	rWfrYuTiEBJYyijx7fUZZginl0ni7Kw2RpAGNgEdifOrNUAaRAT0JD6t6WUEsZkFpjJKHJpo
	CmILC1hJrLo5hw3EZhFQlbj7bSkriM0r4Cpx4uBLFohlchInj01mncDIvYCRYRWjaGppckFx
	UnquoV5xYm5xaV66XnJ+7iZGSIh82cG4+JjVIUYBDkYlHt6CvjUhQqyJZcWVuYcYJTiYlUR4
	3/wCCvGmJFZWpRblxxeV5qQWH2Jk4uCUamBk2fTeV1dSoE4mL1v2OE/2YcWD6m81+A0+rU9M
	+12vySa0e/OnC3O/i0kteh6/+sSX3vWHnpzgfuR1dJ61+3a7V1/Snx9OWTihIbNlU8u2fYku
	glV7/t2fz5vqtuH3y6kxV9hWpW++FyVlE51p9uDBBuO3bKLLX7un8yybuWH1jws6Vb/2ml2c
	osRSnJFoqMVcVJwIAEzLZinvAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor fixes for cleancache about wrong debugfs paths
in documentation and code comment.

Signed-off-by: Marcin Jabrzyk <m.jabrzyk@samsung.com>
---
 Documentation/vm/cleancache.txt | 2 +-
 mm/cleancache.c                 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/vm/cleancache.txt b/Documentation/vm/cleancache.txt
index 142fbb0f325a..01d76282444e 100644
--- a/Documentation/vm/cleancache.txt
+++ b/Documentation/vm/cleancache.txt
@@ -85,7 +85,7 @@ lock the page to ensure serial behavior.
 CLEANCACHE PERFORMANCE METRICS
 
 If properly configured, monitoring of cleancache is done via debugfs in
-the /sys/kernel/debug/mm/cleancache directory.  The effectiveness of cleancache
+the /sys/kernel/debug/cleancache directory.  The effectiveness of cleancache
 can be measured (across all filesystems) with:
 
 succ_gets	- number of gets that were successful
diff --git a/mm/cleancache.c b/mm/cleancache.c
index d0eac4350403..053bcd8f12fb 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -25,7 +25,7 @@
 static struct cleancache_ops *cleancache_ops __read_mostly;
 
 /*
- * Counters available via /sys/kernel/debug/frontswap (if debugfs is
+ * Counters available via /sys/kernel/debug/cleancache (if debugfs is
  * properly configured.  These are for information only so are not protected
  * against increment races.
  */
-- 
1.9.1

