Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757525AbaFSWcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 18:32:20 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:64004 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaFSWcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 18:32:18 -0400
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH] memcg: remove lookup_cgroup_page() prototype
Date: Thu, 19 Jun 2014 15:32:16 -0700
Message-Id: <1403217136-4863-1-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

6b208e3f6e35 ("mm: memcg: remove unused node/section info from
pc->flags") deleted the lookup_cgroup_page() function but left a
prototype for it.

Kill the vestigial prototype.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 include/linux/page_cgroup.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 777a524716db..0ff470de3c12 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -42,7 +42,6 @@ static inline void __init page_cgroup_init(void)
 #endif
 
 struct page_cgroup *lookup_page_cgroup(struct page *page);
-struct page *lookup_cgroup_page(struct page_cgroup *pc);
 
 #define TESTPCGFLAG(uname, lname)			\
 static inline int PageCgroup##uname(struct page_cgroup *pc)	\
-- 
2.0.0.526.g5318336

