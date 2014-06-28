Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaF1Kno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 06:43:44 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:50652 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaF1Knn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 06:43:43 -0400
From: Xie XiuQi <xiexiuqi@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: <rostedt@goodmis.org>, <mingo@redhat.com>, <tony.luck@intel.com>,
        <fweisbec@gmail.com>, <m.chehab@samsung.com>
Subject: [PATCH 2/2] tracing: update Documentation/trace/ftrace.txt for uptime
Date: Sat, 28 Jun 2014 19:10:01 +0800
Message-ID: <1403953801-19068-3-git-send-email-xiexiuqi@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1403953801-19068-1-git-send-email-xiexiuqi@huawei.com>
References: <1403953801-19068-1-git-send-email-xiexiuqi@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

update uptime description.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
---
 Documentation/trace/ftrace.txt | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 2479b2a..7b2e906 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -331,8 +331,7 @@ of ftrace. Here is a list of some of the key files:
 		   know exactly the order events occurred with respect to
 		   each other on different CPUs.
 
-	  uptime: This uses the jiffies counter and the time stamp
-	  	  is relative to the time since boot up.
+	  uptime: This time stamp is relative to the time since boot up.
 
 	  perf: This makes ftrace use the same clock that perf uses.
 	  	Eventually perf will be able to read ftrace buffers
-- 
2.0.0

