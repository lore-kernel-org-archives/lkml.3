Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaA1D3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 22:29:23 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:59365 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347AbaA1D3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 22:29:21 -0500
Message-ID: <52E72405.7070402@huawei.com>
Date: Tue, 28 Jan 2014 11:29:09 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH] cpuset: update MAINTAINERS entry
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add mailing list and tree tag to the entry.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8285ed4..81bcbe0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2376,8 +2376,10 @@ F:	tools/power/cpupower/
 
 CPUSETS
 M:	Li Zefan <lizefan@huawei.com>
+L:	cgroups@vger.kernel.org
 W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
 F:	Documentation/cgroups/cpusets.txt
 F:	include/linux/cpuset.h
-- 
1.8.0.2

