Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967AbaJ3GnF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:43:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37906 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932919AbaJ3GnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:43:02 -0400
Date: Wed, 29 Oct 2014 23:41:56 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-4cdcc33db2f0455f297b4e14e434ba311ec5ca06@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@kernel.org, srikar@linux.vnet.ibm.com,
        hemant@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: tglx@linutronix.de, hemant@linux.vnet.ibm.com,
        srikar@linux.vnet.ibm.com, namhyung@kernel.org, peterz@infradead.org,
        mingo@kernel.org, hpa@zytor.com, masami.hiramatsu.pt@hitachi.com,
        linux-kernel@vger.kernel.org, acme@redhat.com
In-Reply-To: <20141027203124.21219.68278.stgit@localhost.localdomain>
References: <20141027203124.21219.68278.stgit@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Trivial typo fix for --demangle
Git-Commit-ID: 4cdcc33db2f0455f297b4e14e434ba311ec5ca06
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

Commit-ID:  4cdcc33db2f0455f297b4e14e434ba311ec5ca06
Gitweb:     http://git.kernel.org/tip/4cdcc33db2f0455f297b4e14e434ba311ec5ca06
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 27 Oct 2014 16:31:24 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:30:18 -0200

perf probe: Trivial typo fix for --demangle

Replace "Disable" with "Enable", since --demangle option enables symbol
demangling, not disable it.

perf probe has --demangle and --no-demangle options, but the
command-line help (--help) shows only --demangle option. So it should
explain about --demangle.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20141027203124.21219.68278.stgit@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 04412b4..7af26ac 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -375,7 +375,7 @@ __cmd_probe(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK('x', "exec", NULL, "executable|path",
 			"target executable name or path", opt_set_target),
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
-		    "Disable symbol demangling"),
+		    "Enable symbol demangling"),
 	OPT_BOOLEAN(0, "demangle-kernel", &symbol_conf.demangle_kernel,
 		    "Enable kernel symbol demangling"),
 	OPT_END()
