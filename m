Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965324Ab3FTKHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:07:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:43495 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S965260Ab3FTKH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:07:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,903,1363104000"; 
   d="scan'208";a="7614623"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: bcrl@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
        trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] memblock: Fix wrong comment in __next_free_mem_range()
Date: Thu, 20 Jun 2013 18:10:22 +0800
Message-Id: <1371723023-4060-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1371723023-4060-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 18:06:16,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 18:06:17,
	Serialize complete at 2013/06/20 18:06:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove one redundant "nid" in the comment.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 mm/memblock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index c5fad93..a847bfe 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -566,7 +566,7 @@ int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 /**
  * __next_free_mem_range - next function for for_each_free_mem_range()
  * @idx: pointer to u64 loop variable
- * @nid: nid: node selector, %MAX_NUMNODES for all nodes
+ * @nid: node selector, %MAX_NUMNODES for all nodes
  * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @out_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @out_nid: ptr to int for nid of the range, can be %NULL
-- 
1.7.1

