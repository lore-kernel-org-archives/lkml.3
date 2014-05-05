Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920AbaEEIFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 04:05:47 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:46977 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754778AbaEEIFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 04:05:44 -0400
X-IronPort-AV: E=Sophos;i="4.97,985,1389715200"; 
   d="scan'208";a="30073731"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: <jolsa@redhat.com>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <linux-kernel@vger.kernel.org>,
        Dongsheng <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 2/3] perf tools: Adapt the TASK_STATE_TO_CHAR_STR to new value in kernel space.
Date: Mon, 5 May 2014 16:05:54 +0900
Message-ID: <6d2f55dc1e02c1e29a5d70bfeb9d6e8863caf2aa.1399273302.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1399273302.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1399273302.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng <yangds.fnst@cn.fujitsu.com>

Currently, TASK_STATE_TO_CHAR_STR in kernel space is already expanded to RSDTtZXxKWP,
but it is still RSDTtZX in perf sched tool.

This patch update TASK_STATE_TO_CHAR_STR to the new value in kernel space.

Signed-off-by: Dongsheng <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-sched.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 7eae501..4f0dd21 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -66,7 +66,7 @@ struct sched_atom {
 	struct task_desc	*wakee;
 };
 
-#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+#define TASK_STATE_TO_CHAR_STR "RSDTtZXxKWP"
 
 enum thread_state {
 	THREAD_SLEEPING = 0,
-- 
1.8.2.1

