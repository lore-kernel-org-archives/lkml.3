Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045Ab3EQD3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 23:29:46 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:64580 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3EQD3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 23:29:45 -0400
Message-ID: <5195A41D.7050507@huawei.com>
Date: Fri, 17 May 2013 11:29:33 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH] memcg: update TODO list in Documentation
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hugetlb cgroup has already been implemented.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 Documentation/cgroups/memory.txt | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index ddf4f93..327acec 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -834,10 +834,9 @@ Test:
 
 12. TODO
 
-1. Add support for accounting huge pages (as a separate controller)
-2. Make per-cgroup scanner reclaim not-shared pages first
-3. Teach controller to account for shared-pages
-4. Start reclamation in the background when the limit is
+1. Make per-cgroup scanner reclaim not-shared pages first
+2. Teach controller to account for shared-pages
+3. Start reclamation in the background when the limit is
    not yet hit but the usage is getting closer
 
 Summary
-- 
1.8.0.2
