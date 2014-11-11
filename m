Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbaKKDWG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 22:22:06 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:49542 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaKKDWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 22:22:04 -0500
From: Xie XiuQi <xiexiuqi@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-doc@vger.kernel.org>, <paulmck@linux.vnet.ibm.com>,
        <josh@joshtriplett.org>, <rostedt@goodmis.org>,
        <mathieu.desnoyers@efficios.com>, <laijs@cn.fujitsu.com>,
        <corbet@lwn.net>, <mingo@kernel.org>
Subject: [PATCH] documentation: Update sysfs path for rcu_cpu_stall_timeout
Date: Tue, 11 Nov 2014 12:03:26 +0800
Message-ID: <1415678606-28216-1-git-send-email-xiexiuqi@huawei.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.546180CB.0107,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: a09fc78026a2e37758451c14052d3300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 6bfc09e2327d ("rcu: Provide RCU CPU stall warnings for tiny RCU")
moved the rcu_cpu_stall_timeout module parameter from rcutree.c to
rcupdate.c, but failed to update Documentation/RCU/stallwarn.txt. This
commit therefore repairs this omission.

commit 96224daa16d6 ("documentation: Update sysfs path for rcu_cpu_stall_suppress")
updated the path for rcu_cpu_stall_suppress, but failed to update for
rcu_cpu_stall_timeout.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 Documentation/RCU/stallwarn.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
index ef5a2fd..da6a801 100644
--- a/Documentation/RCU/stallwarn.txt
+++ b/Documentation/RCU/stallwarn.txt
@@ -15,7 +15,7 @@ CONFIG_RCU_CPU_STALL_TIMEOUT
 	21 seconds.
 
 	This configuration parameter may be changed at runtime via the
-	/sys/module/rcutree/parameters/rcu_cpu_stall_timeout, however
+	/sys/module/rcupdate/parameters/rcu_cpu_stall_timeout, however
 	this parameter is checked only at the beginning of a cycle.
 	So if you are 10 seconds into a 40-second stall, setting this
 	sysfs parameter to (say) five will shorten the timeout for the
-- 
1.7.1

