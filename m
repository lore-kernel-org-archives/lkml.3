Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbaJBP50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:57:26 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:58572 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJBP5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:57:25 -0400
From: Paul McQuade <paulmcquad@gmail.com>
To: paulmcquad@gmail.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, davidlohr@hp.com, lcapitulino@redhat.com,
        iamjoonsoo.kim@lge.com, aarcange@redhat.com,
        kirill.shutemov@linux.intel.com
Subject: [PATCH] mm: hugetlb braces not needed
Date: Thu,  2 Oct 2014 16:57:19 +0100
Message-Id: <1412265439-3654-1-git-send-email-paulmcquad@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

braces {} are not necessary for any arm of this statement

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/hugetlb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eeceeeb..565b403 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -106,11 +106,11 @@ static int hugepage_subpool_get_pages(struct hugepage_subpool *spool,
 		return 0;
 
 	spin_lock(&spool->lock);
-	if ((spool->used_hpages + delta) <= spool->max_hpages) {
+	if ((spool->used_hpages + delta) <= spool->max_hpages)
 		spool->used_hpages += delta;
-	} else {
+	else
 		ret = -ENOMEM;
-	}
+
 	spin_unlock(&spool->lock);
 
 	return ret;
-- 
1.9.1

