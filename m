Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759279Ab3EAWRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 18:17:34 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58555 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383Ab3EAWRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 18:17:32 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 2/4] mm: fix comment referring to non-existent size_seqlock, change to span_seqlock
Date: Wed,  1 May 2013 15:17:13 -0700
Message-Id: <1367446635-12856-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1367446635-12856-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050122-7182-0000-0000-0000067F1AE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/mmzone.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 09ac172..afd0aa5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -719,7 +719,7 @@ typedef struct pglist_data {
 	 * Updaters of any of these fields also must hold
 	 * lock_memory_hotplug().
 	 *
-	 * Nests above zone->lock and zone->size_seqlock.
+	 * Nests above zone->lock and zone->span_seqlock
 	 */
 	spinlock_t node_size_lock;
 #endif
-- 
1.8.2.2

