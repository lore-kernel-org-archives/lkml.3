Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaLSFrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 00:47:08 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:20048 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964AbaLSFrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 00:47:06 -0500
From: Li Bin <huawei.libin@huawei.com>
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>, <xiexiuqi@huawei.com>
Subject: [PATCH] ftrace: fix typo in comment
Date: Fri, 19 Dec 2014 14:27:53 +0800
Message-ID: <1418970473-29556-1-git-send-email-huawei.libin@huawei.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

%s/ARCH_SUPPORT_FTARCE_OPS/ARCH_SUPPORTS_FTRACE_OPS/

Signed-off-by: Li Bin <huawei.libin@huawei.com>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 929a733..9473b24 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -5102,7 +5102,7 @@ out:
  * being NULL, or CONFIG_DYNAMIC_FTRACE_WITH_REGS.
  * Note, CONFIG_DYNAMIC_FTRACE_WITH_REGS expects a full regs to be saved.
  * An architecture can pass partial regs with ftrace_ops and still
- * set the ARCH_SUPPORT_FTARCE_OPS.
+ * set the ARCH_SUPPORTS_FTRACE_OPS.
  */
 #if ARCH_SUPPORTS_FTRACE_OPS
 static void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
-- 
1.7.1

