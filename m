Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3CRDHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 23:07:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:65080 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3CRDHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 23:07:36 -0400
Message-ID: <514684EE.6000805@huawei.com>
Date: Mon, 18 Mar 2013 11:07:26 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] tracing: remove obsolete macro guard _TRACE_PROFILE_INIT
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro _TRACE_PROFILE_INIT was removed at long time ago,
but leave guard "#undef" here, remove it.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/trace/ftrace.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 40dc5e8..a194753 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -705,5 +705,3 @@ static inline void perf_test_probe_##call(void)				\
 #include TRACE_INCLUDE(TRACE_INCLUDE_FILE)
 #endif /* CONFIG_PERF_EVENTS */

-#undef _TRACE_PROFILE_INIT
-
-- 
1.7.9.7


