Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3C0JwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 05:52:17 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:64357 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3C0Jtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 05:49:40 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 09/14] tracing: remove obsolete macro guard _TRACE_PROFILE_INIT
Date: Wed, 27 Mar 2013 17:48:51 +0800
Message-ID: <1364377737-10540-11-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1364377737-10540-1-git-send-email-jovi.zhangwei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

Macro _TRACE_PROFILE_INIT was removed at long time ago,
but leave guard "#undef" here, remove it.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/trace/ftrace.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index e4ea38c..cdf6a2c 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -677,5 +677,3 @@ static inline void perf_test_probe_##call(void)				\
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 #endif /* CONFIG_PERF_EVENTS */
 
-#undef _TRACE_PROFILE_INIT
-
-- 
1.7.9.7


