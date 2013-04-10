Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936465Ab3DJD1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:27:25 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:28076 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934499Ab3DJD1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:27:19 -0400
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
To: <rostedt@goodmis.org>, <fweisbec@gmail.com>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>
CC: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH v3 08/12] tracing: remove obsolete macro guard _TRACE_PROFILE_INIT
Date: Wed, 10 Apr 2013 11:26:29 +0800
Message-ID: <1365564393-10972-9-git-send-email-jovi.zhangwei@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
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
index 743e754..b95cc52 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -677,5 +677,3 @@ static inline void perf_test_probe_##call(void)				\
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 #endif /* CONFIG_PERF_EVENTS */
 
-#undef _TRACE_PROFILE_INIT
-
-- 
1.7.9.7


