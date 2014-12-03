Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaLCLyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:54:20 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48305 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaLCLyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:54:08 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: tj@kernel.org
Cc: lizefan@huawei.com, corbet@lwn.net, trivial@kernel.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH 2/2] cgroups: Documentation: fix trivial typos and wrong paragraph numberings
Date: Wed,  3 Dec 2014 20:53:45 +0900
Message-Id: <1417607625-2775-2-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417607625-2775-1-git-send-email-sj38.park@gmail.com>
References: <1417607625-2775-1-git-send-email-sj38.park@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/cgroups/cpusets.txt | 6 +++---
 Documentation/cgroups/memory.txt  | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/cgroups/cpusets.txt b/Documentation/cgroups/cpusets.txt
index 3c94ff3..f2235a1 100644
--- a/Documentation/cgroups/cpusets.txt
+++ b/Documentation/cgroups/cpusets.txt
@@ -445,7 +445,7 @@ across partially overlapping sets of CPUs would risk unstable dynamics
 that would be beyond our understanding.  So if each of two partially
 overlapping cpusets enables the flag 'cpuset.sched_load_balance', then we
 form a single sched domain that is a superset of both.  We won't move
-a task to a CPU outside it cpuset, but the scheduler load balancing
+a task to a CPU outside its cpuset, but the scheduler load balancing
 code might waste some compute cycles considering that possibility.
 
 This mismatch is why there is not a simple one-to-one relation
@@ -552,8 +552,8 @@ otherwise initial value -1 that indicates the cpuset has no request.
    1  : search siblings (hyperthreads in a core).
    2  : search cores in a package.
    3  : search cpus in a node [= system wide on non-NUMA system]
- ( 4  : search nodes in a chunk of node [on NUMA system] )
- ( 5  : search system wide [on NUMA system] )
+   4  : search nodes in a chunk of node [on NUMA system]
+   5  : search system wide [on NUMA system]
 
 The system default is architecture dependent.  The system default
 can be changed using the relax_domain_level= boot parameter.
diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 46b2b50..a22df3a 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -326,7 +326,7 @@ per cgroup, instead of globally.
 
 * tcp memory pressure: sockets memory pressure for the tcp protocol.
 
-2.7.3 Common use cases
+2.7.2 Common use cases
 
 Because the "kmem" counter is fed to the main user counter, kernel memory can
 never be limited completely independently of user memory. Say "U" is the user
@@ -354,19 +354,19 @@ set:
 
 3. User Interface
 
-0. Configuration
+3.0. Configuration
 
 a. Enable CONFIG_CGROUPS
 b. Enable CONFIG_MEMCG
 c. Enable CONFIG_MEMCG_SWAP (to use swap extension)
 d. Enable CONFIG_MEMCG_KMEM (to use kmem extension)
 
-1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
+3.1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
 # mount -t tmpfs none /sys/fs/cgroup
 # mkdir /sys/fs/cgroup/memory
 # mount -t cgroup none /sys/fs/cgroup/memory -o memory
 
-2. Make the new group and move bash into it
+3.2. Make the new group and move bash into it
 # mkdir /sys/fs/cgroup/memory/0
 # echo $$ > /sys/fs/cgroup/memory/0/tasks
 
-- 
1.9.1

