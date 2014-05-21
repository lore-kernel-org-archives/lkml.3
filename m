Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaEUSRf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:17:35 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:29077 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751257AbaEUSRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:17:34 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AugLAPLsfFNbsHTp/2dsb2JhbABZgwmCRahABAEBAQEBAQUBgzqWdoEMF3SCZhwjGIECJBOIRQHWX4VViBVkhEcBA41VgWiKMAGHaos6gzo7gTE
Date: Wed, 21 May 2014 20:17:22 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/1] lib/radix-tree.c: kernel-doc warning fix
Message-Id: <20140521201722.c4b2f39d062752c04e1b446c@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

index has been removed from __radix_tree_delete_node in
449dd6984d0e47
("mm: keep page cache radix tree nodes in check")

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 lib/radix-tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 9599aa7..5925956 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1296,7 +1296,6 @@ static inline void radix_tree_shrink(struct radix_tree_root *root)
 /**
  *	__radix_tree_delete_node    -    try to free node after clearing a slot
  *	@root:		radix tree root
- *	@index:		index key
  *	@node:		node containing @index
  *
  *	After clearing the slot at @index in @node from radix tree
-- 
1.9.1
