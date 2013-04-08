Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3DHI5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 04:57:52 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:62138 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3DHI5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 04:57:51 -0400
Date: Mon, 8 Apr 2013 01:57:46 -0700
From: Michel Lespinasse <walken@google.com>
To: Glauber Costa <glommer@parallels>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] mm/memcontrol.c: trivial fix - remove unnecessary ;
Message-ID: <20130408085746.GA4668@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a trivial issue I stumbled on while doing something else...

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2b552224f5cf..dceee534b4b5 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5744,7 +5744,7 @@ static int memcg_init_kmem(struct mem_cgroup *memcg, struct cgroup_subsys *ss)
 		return ret;
 
 	return mem_cgroup_sockets_init(memcg, ss);
-};
+}
 
 static void kmem_cgroup_destroy(struct mem_cgroup *memcg)
 {


-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
