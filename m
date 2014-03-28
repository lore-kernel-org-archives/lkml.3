Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaC2P05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 11:26:57 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:62903 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbaC2P0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 11:26:53 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH v2 18/29] ktap: add Kconfig(kernel/trace/ktap/Kconfig)
Date: Fri, 28 Mar 2014 10:45:13 -0400
Message-Id: <1396017924-7754-19-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396017924-7754-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 kernel/trace/ktap/Kconfig | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 kernel/trace/ktap/Kconfig

diff --git a/kernel/trace/ktap/Kconfig b/kernel/trace/ktap/Kconfig
new file mode 100644
index 0000000..21f8d2e
--- /dev/null
+++ b/kernel/trace/ktap/Kconfig
@@ -0,0 +1,21 @@
+config KTAP
+	tristate "a programable dynamic tracing tool for Linux"
+	depends on PERF_EVENTS && EVENT_TRACING
+	default n
+	help
+	  ktap is a new script-based dynamic tracing tool for Linux,
+	  it uses a scripting language and lets users trace the
+	  Linux kernel dynamically. ktap is designed to give
+	  operational insights with interoperability that allow
+	  users to tune, troubleshoot and extend kernel and application.
+	  It's similar with Linux Systemtap and Solaris Dtrace.
+
+	  ktap have different design principles from Linux mainstream
+	  dynamic tracing language in that it's based on bytecode,
+	  so it doesn't depend upon GCC, doesn't require compiling
+	  kernel module for each script, safe to use in production
+	  environment, fulfilling the embedded ecosystem's tracing needs.
+
+	  See ktap tutorial for more information:
+	      http://www.ktap.org/doc/tutorial.html
+
-- 
1.8.1.4

