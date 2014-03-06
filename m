Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaCFJTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:19:33 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47084 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbaCFJTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:19:30 -0500
From: Choi Gi-yong <yong@gnoy.org>
To: iamjoonsoo.kim@lge.com
Cc: linux-kernel@vger.kernel.org, Choi Gi-yong <yong@gnoy.org>
Subject: [PATCH] mm: fixed coding style Fix coding style of hugetlb.c Singed-off-by: Choi Gi-yong <yong@gnoy.org>
Date: Thu,  6 Mar 2014 18:19:24 +0900
Message-Id: <1394097564-11309-1-git-send-email-yong@gnoy.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 mm/hugetlb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 2252cac..fe894f7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2896,8 +2896,7 @@ retry:
 	if (anon_rmap) {
 		ClearPagePrivate(page);
 		hugepage_add_new_anon_rmap(page, vma, address);
-	}
-	else
+	} else
 		page_dup_rmap(page);
 	new_pte = make_huge_pte(vma, page, ((vma->vm_flags & VM_WRITE)
 				&& (vma->vm_flags & VM_SHARED)));
-- 
1.8.3.2

