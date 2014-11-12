Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaKLWdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:33:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbaKLWdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:33:52 -0500
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andi@firstfloor.org, rientjes@google.com, riel@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, yinghai@kernel.org, davidlohr@hp.com
Subject: [PATCH 3/3] hugetlb: hugetlb_register_all_nodes(): add __init marker
Date: Wed, 12 Nov 2014 17:33:13 -0500
Message-Id: <1415831593-9020-4-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com>
References: <1415831593-9020-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is only called during initialization.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a10fd57..9785546 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2083,7 +2083,7 @@ static void hugetlb_register_node(struct node *node)
  * devices of nodes that have memory.  All on-line nodes should have
  * registered their associated device by this time.
  */
-static void hugetlb_register_all_nodes(void)
+static void __init hugetlb_register_all_nodes(void)
 {
 	int nid;
 
-- 
1.9.3

