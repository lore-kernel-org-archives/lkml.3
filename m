Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaAMUyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 15:54:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40420 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbaAMUsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 15:48:09 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 32/38] tools include: Include <linux/compiler.h> from asm/bug.h
Date: Mon, 13 Jan 2014 17:47:33 -0300
Message-Id: <1389646059-24881-33-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389646059-24881-1-git-send-email-acme@infradead.org>
References: <1389646059-24881-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Since it uses unlikely() macro inside WARN()

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1389276059-8829-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/include/asm/bug.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/include/asm/bug.h b/tools/include/asm/bug.h
index eca78df7b8f2..9e5f4846967f 100644
--- a/tools/include/asm/bug.h
+++ b/tools/include/asm/bug.h
@@ -1,6 +1,8 @@
 #ifndef _TOOLS_ASM_BUG_H
 #define _TOOLS_ASM_BUG_H
 
+#include <linux/compiler.h>
+
 #define __WARN_printf(arg...)	do { fprintf(stderr, arg); } while (0)
 
 #define WARN(condition, format...) ({		\
-- 
1.8.1.4

