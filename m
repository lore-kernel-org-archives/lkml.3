Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaKXQiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 11:38:18 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:43137 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaKXQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 11:38:16 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: tj@kernel.org
Cc: lizefan@huawei.com, corbet@lwn.net, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] cgroups: Documentation: fix wrong cgroupfs paths
Date: Tue, 25 Nov 2014 01:39:19 +0900
Message-Id: <1416847159-3895-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Few paths used as example to describe cgroupfs usage have been wrong
from f6e07d38078e ("Documentation: update cgroupfs mount point") by
mistake. This patch fix those trivial wrong paths.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/cgroups/cgroups.txt | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 10c949b..f935fac 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -312,10 +312,10 @@ the "cpuset" cgroup subsystem, the steps are something like:
  2) mkdir /sys/fs/cgroup/cpuset
  3) mount -t cgroup -ocpuset cpuset /sys/fs/cgroup/cpuset
  4) Create the new cgroup by doing mkdir's and write's (or echo's) in
-    the /sys/fs/cgroup virtual file system.
+    the /sys/fs/cgroup/cpuset virtual file system.
  5) Start a task that will be the "founding father" of the new job.
  6) Attach that task to the new cgroup by writing its PID to the
-    /sys/fs/cgroup/cpuset/tasks file for that cgroup.
+    /sys/fs/cgroup/cpuset tasks file for that cgroup.
  7) fork, exec or clone the job tasks from this founding father task.
 
 For example, the following sequence of commands will setup a cgroup
-- 
1.9.1

