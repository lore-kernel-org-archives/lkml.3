Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3EMXNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 19:13:36 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45494 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab3EMXNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 19:13:31 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v3 1/4] mm: fix comment referring to non-existent size_seqlock, change to span_seqlock
Date: Mon, 13 May 2013 16:13:04 -0700
Message-Id: <1368486787-9511-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1368486787-9511-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368486787-9511-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051323-5806-0000-0000-0000211E6198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
---
 include/linux/mmzone.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 5c76737..fc859a0c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -716,7 +716,7 @@ typedef struct pglist_data {
 	 * or node_spanned_pages stay constant.  Holding this will also
 	 * guarantee that any pfn_valid() stays that way.
 	 *
-	 * Nests above zone->lock and zone->size_seqlock.
+	 * Nests above zone->lock and zone->span_seqlock
 	 */
 	spinlock_t node_size_lock;
 #endif
-- 
1.8.2.2

