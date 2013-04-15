Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab3DOJoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:44:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:34456 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab3DOJoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:44:19 -0400
X-IronPort-AV: E=Sophos;i="4.87,475,1363104000"; 
   d="scan'208";a="7057092"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, yinghai@kernel.org, akpm@linux-foundation.org,
        wency@cn.fujitsu.com, mgorman@suse.de, tj@kernel.org,
        liwanp@linux.vnet.ibm.com
Cc: tangchen@cn.fujitsu.com, linux-mm@kvack.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] memblock: Fix missing comment of memblock_insert_region().
Date: Mon, 15 Apr 2013 17:46:47 +0800
Message-Id: <1366019207-27818-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1366019207-27818-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1366019207-27818-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 17:42:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 17:42:35,
	Serialize complete at 2013/04/15 17:42:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no comment for parameter nid of memblock_insert_region().
This patch adds comment for it.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 mm/memblock.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b8d9147..16eda3d 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -322,10 +322,11 @@ static void __init_memblock memblock_merge_regions(struct memblock_type *type)
 
 /**
  * memblock_insert_region - insert new memblock region
- * @type: memblock type to insert into
- * @idx: index for the insertion point
- * @base: base address of the new region
- * @size: size of the new region
+ * @type:	memblock type to insert into
+ * @idx:	index for the insertion point
+ * @base:	base address of the new region
+ * @size:	size of the new region
+ * @nid:	node id of the new region
  *
  * Insert new memblock region [@base,@base+@size) into @type at @idx.
  * @type must already have extra room to accomodate the new region.
-- 
1.7.1

