Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3AKJ3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 04:29:30 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:50913 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3AKJ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 04:29:27 -0500
Message-ID: <50EFDB6D.9070309@huawei.com>
Date: Fri, 11 Jan 2013 17:29:17 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Paul Menage <paul@paulmenage.org>
Subject: [PATCH] cpuset: update MAINTAINERS
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As Paul doesn't maintain cpusets anymore, I'll take over the
maintainership.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fa309ab..d58bc12 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2128,10 +2128,10 @@ S:	Maintained
 F:	tools/power/cpupower
 
 CPUSETS
-M:	Paul Menage <paul@paulmenage.org>
+M:	Li Zefan <lizefan@huawei.com>
 W:	http://www.bullopensource.org/cpuset/
 W:	http://oss.sgi.com/projects/cpusets/
-S:	Supported
+S:	Maintained
 F:	Documentation/cgroups/cpusets.txt
 F:	include/linux/cpuset.h
 F:	kernel/cpuset.c
-- 
1.8.0.2

