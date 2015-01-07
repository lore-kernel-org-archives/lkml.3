Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347AbbAGJkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:40:09 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:53252 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbbAGJkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:40:04 -0500
From: Fabian Holler <fabian.holler@profitbricks.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabian Holler <fabian.holler@profitbricks.com>
Subject: [PATCH 1/3] staging: android: fix indentation to match open parenthesis
Date: Wed,  7 Jan 2015 10:39:52 +0100
Message-Id: <31b74854ae586f183c5216ee7fae2021c8e70ab7.1420622282.git.fabian.holler@profitbricks.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <cover.1420622282.git.fabian.holler@profitbricks.com>
References: <cover.1420622282.git.fabian.holler@profitbricks.com>
In-Reply-To: <cover.1420622282.git.fabian.holler@profitbricks.com>
References: <cover.1420622282.git.fabian.holler@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches fixes the following checkpatch.pl warning:
	ashmem.c:450: CHECK:PARENTHESIS_ALIGNMENT: Alignment should match open parenthesis

Signed-off-by: Fabian Holler <fabian.holler@profitbricks.com>
---
 drivers/staging/android/ashmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 8c78527..181a71e 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -447,8 +447,8 @@ ashmem_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 		loff_t end = (range->pgend + 1) * PAGE_SIZE;
 
 		vfs_fallocate(range->asma->file,
-				FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
-				start, end - start);
+			      FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			      start, end - start);
 		range->purged = ASHMEM_WAS_PURGED;
 		lru_del(range);
 
-- 
2.1.3

