Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932254AbaKSQFD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:05:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:51721 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbaKSQE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:04:59 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/16] perf tools: Add perf-read-vdso32 and perf-read-vdsox32 to .gitignore
Date: Wed, 19 Nov 2014 13:03:35 -0300
Message-Id: <1416413016-19110-16-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Recently added executables Add perf-read-vdso32 and perf-read-vdsox32
need to be added to .gitignore.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415715423-15563-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 717221e98450..40399c3d97d6 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -2,6 +2,8 @@ PERF-CFLAGS
 PERF-GUI-VARS
 PERF-VERSION-FILE
 perf
+perf-read-vdso32
+perf-read-vdsox32
 perf-help
 perf-record
 perf-report
-- 
1.9.3

