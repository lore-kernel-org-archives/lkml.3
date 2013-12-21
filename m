Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3LUP5y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 10:57:54 -0500
Received: from mail-gg0-f172.google.com ([209.85.161.172]:60871 "EHLO
	mail-gg0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991Ab3LUP5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 10:57:52 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, tj@kernel.org,
        lizefan@huawei.com, rob@landley.net
Cc: linux-doc@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] doc: cgroups: Fix typo in doc/cgroups
Date: Sun, 22 Dec 2013 00:57:33 +0900
Message-Id: <1387641453-13803-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in memory.txt and
resource_counter.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/cgroups/memory.txt           | 4 ++--
 Documentation/cgroups/resource_counter.txt | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index e2bc132..2622115 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -577,7 +577,7 @@ Each memcg's numa_stat file includes "total", "file", "anon" and "unevictable"
 per-node page counts including "hierarchical_<counter>" which sums up all
 hierarchical children's values in addition to the memcg's own value.
 
-The ouput format of memory.numa_stat is:
+The output format of memory.numa_stat is:
 
 total=<total pages> N0=<node 0 pages> N1=<node 1 pages> ...
 file=<total file pages> N0=<node 0 pages> N1=<node 1 pages> ...
@@ -670,7 +670,7 @@ page tables.
 
 8.1 Interface
 
-This feature is disabled by default. It can be enabledi (and disabled again) by
+This feature is disabled by default. It can be enabled (and disabled again) by
 writing to memory.move_charge_at_immigrate of the destination cgroup.
 
 If you want to enable it:
diff --git a/Documentation/cgroups/resource_counter.txt b/Documentation/cgroups/resource_counter.txt
index c4d99ed..52e1da1 100644
--- a/Documentation/cgroups/resource_counter.txt
+++ b/Documentation/cgroups/resource_counter.txt
@@ -97,8 +97,8 @@ to work with it.
 		(struct res_counter *rc, struct res_counter *top,
 		 unsinged long val)
 
-	Almost same as res_cunter_uncharge() but propagation of uncharge
-	stops when rc == top. This is useful when kill a res_coutner in
+	Almost same as res_counter_uncharge() but propagation of uncharge
+	stops when rc == top. This is useful when kill a res_counter in
 	child cgroup.
 
  2.1 Other accounting routines
-- 
1.8.5.2.192.g7794a68

