Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbaC1N5t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:57:49 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61895 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaC1N5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:57:45 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH 25/28] ktap: add Kconfig
Date: Fri, 28 Mar 2014 09:47:46 -0400
Message-Id: <1396014469-5937-26-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/Kconfig | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)
 create mode 100644 tools/ktap/Kconfig

diff --git a/tools/ktap/Kconfig b/tools/ktap/Kconfig
new file mode 100644
index 0000000..21f8d2e
--- /dev/null
+++ b/tools/ktap/Kconfig
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

