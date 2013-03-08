Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290Ab3CHPw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:52:56 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:44135 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab3CHPwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:52:54 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, wency@cn.fujitsu.com,
        tangchen@cn.fujitsu.com, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 1/2] mm: walk_memory_range: Fix typo in comment
Date: Fri,  8 Mar 2013 08:41:40 -0700
Message-Id: <1362757301-18550-1-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a typo "end_pft" in the comment of walk_memory_range().

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
---
 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index b81a367b..ae7bcba 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1613,7 +1613,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages)
 /**
  * walk_memory_range - walks through all mem sections in [start_pfn, end_pfn)
  * @start_pfn: start pfn of the memory range
- * @end_pfn: end pft of the memory range
+ * @end_pfn: end pfn of the memory range
  * @arg: argument passed to func
  * @func: callback for each memory section walked
  *
