Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaJOKEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:04:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54325 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423AbaJOKEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:04:34 -0400
Date: Wed, 15 Oct 2014 03:03:22 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-jlpybqegpdauzx64l9r1jgm3@git.kernel.org>
Cc: mingo@kernel.org, fweisbec@gmail.com, tglx@linutronix.de,
        namhyung@kernel.org, dsahern@gmail.com, paulus@samba.org,
        jean.pihet@linaro.org, jolsa@redhat.com, acme@redhat.com,
        dzickus@redhat.com, adrian.hunter@intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, eranian@google.com, efault@gmx.de,
        peterz@infradead.org, bp@suse.de
Reply-To: efault@gmx.de, peterz@infradead.org, bp@suse.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, eranian@google.com, namhyung@kernel.org,
        paulus@samba.org, dsahern@gmail.com, jean.pihet@linaro.org,
        jolsa@redhat.com, acme@redhat.com, dzickus@redhat.com,
        adrian.hunter@intel.com, fweisbec@gmail.com, mingo@kernel.org,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf ui browsers: Add missing include
Git-Commit-ID: 95e8d97e9b78040285defe482e1edf8b6341a4c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95e8d97e9b78040285defe482e1edf8b6341a4c1
Gitweb:     http://git.kernel.org/tip/95e8d97e9b78040285defe482e1edf8b6341a4c1
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 10 Oct 2014 15:39:02 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 10 Oct 2014 15:53:42 -0300

perf ui browsers: Add missing include

This file needs the K_{RIGHT,etc} definitions but isn't including the
file where they are defined, ui/keysyms.h, fix it.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jlpybqegpdauzx64l9r1jgm3@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/header.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/ui/browsers/header.c b/tools/perf/ui/browsers/header.c
index 89c16b9..e8278c5 100644
--- a/tools/perf/ui/browsers/header.c
+++ b/tools/perf/ui/browsers/header.c
@@ -1,6 +1,7 @@
 #include "util/cache.h"
 #include "util/debug.h"
 #include "ui/browser.h"
+#include "ui/keysyms.h"
 #include "ui/ui.h"
 #include "ui/util.h"
 #include "ui/libslang.h"
