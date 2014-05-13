Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbaEMTuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:50:09 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52666 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbaEMTuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:50:02 -0400
Date: Tue, 13 May 2014 15:49:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH cgroup/for-3.16] cgroup: clean up MAINTAINERS entries
Message-ID: <20140513194958.GD28815@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are currently three cgroup related entries in MAINTAINERS.  Make
the following updates.

* Make the names - both cgroup and cpuset - singular.  We're mixing
  singular and plural all over the place for no good reason.

* Drop containers@lists.linux-foundation.org from CGROUP.  That list
  doesn't have much to do with cgroup per-se.

* Add Documentation field to CGROUP.

* Drop mm/*cgroup* from CGROUP.  memcg has separate maintainers.

* Prefix the controller-specific ones with "CONTROL CGROUP -" and
  collect cgroup related entries under the core one.

* Add (MEMCG) abbreviation to MEMCG entry.

* Drop Balbir Singh and KAMEZAWA Hiroyuki from memcg maintainers.  It
  has been quite a while since both actually worked on memcg.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Hello,

Summer house cleaning.  If there's any objection, please let me know.

Thanks.

 MAINTAINERS |   47 ++++++++++++++++++++++-------------------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e67ea24..7202bec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2382,16 +2382,35 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/connector/
 
-CONTROL GROUPS (CGROUPS)
+CONTROL GROUP (CGROUP)
 M:	Tejun Heo <tj@kernel.org>
 M:	Li Zefan <lizefan@huawei.com>
-L:	containers@lists.linux-foundation.org
 L:	cgroups@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
+F:	Documentation/cgroups/
 F:	include/linux/cgroup*
 F:	kernel/cgroup*
-F:	mm/*cgroup*
+
+CONTROL GROUP - CPUSET
+M:	Li Zefan <lizefan@huawei.com>
+L:	cgroups@vger.kernel.org
+W:	http://www.bullopensource.org/cpuset/
+W:	http://oss.sgi.com/projects/cpusets/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
+S:	Maintained
+F:	Documentation/cgroups/cpusets.txt
+F:	include/linux/cpuset.h
+F:	kernel/cpuset.c
+
+CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
+M:	Johannes Weiner <hannes@cmpxchg.org>
+M:	Michal Hocko <mhocko@suse.cz>
+L:	cgroups@vger.kernel.org
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	mm/memcontrol.c
+F:	mm/page_cgroup.c
 
 CORETEMP HARDWARE MONITORING DRIVER
 M:	Fenghua Yu <fenghua.yu@intel.com>
@@ -2464,17 +2483,6 @@ M:	Thomas Renninger <trenn@suse.de>
 S:	Maintained
 F:	tools/power/cpupower/
 
-CPUSETS
-M:	Li Zefan <lizefan@huawei.com>
-L:	cgroups@vger.kernel.org
-W:	http://www.bullopensource.org/cpuset/
-W:	http://oss.sgi.com/projects/cpusets/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
-S:	Maintained
-F:	Documentation/cgroups/cpusets.txt
-F:	include/linux/cpuset.h
-F:	kernel/cpuset.c
-
 CRAMFS FILESYSTEM
 W:	http://sourceforge.net/projects/cramfs/
 S:	Orphan / Obsolete
@@ -5731,17 +5739,6 @@ F:	include/linux/memory_hotplug.h
 F:	include/linux/vmalloc.h
 F:	mm/
 
-MEMORY RESOURCE CONTROLLER
-M:	Johannes Weiner <hannes@cmpxchg.org>
-M:	Michal Hocko <mhocko@suse.cz>
-M:	Balbir Singh <bsingharora@gmail.com>
-M:	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
-L:	cgroups@vger.kernel.org
-L:	linux-mm@kvack.org
-S:	Maintained
-F:	mm/memcontrol.c
-F:	mm/page_cgroup.c
-
 MEMORY TECHNOLOGY DEVICES (MTD)
 M:	David Woodhouse <dwmw2@infradead.org>
 M:	Brian Norris <computersforpeace@gmail.com>
