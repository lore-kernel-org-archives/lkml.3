Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaJ0MfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:35:11 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:57923 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaJ0MfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:35:10 -0400
Subject: [PATCH perf/core 1/2] [BUGFIX] perf-probe: a trivial typo fix for
 --demangle
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        namhyung@kernel.org, Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Mon, 27 Oct 2014 16:31:24 -0400
Message-ID: <20141027203124.21219.68278.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace "Disable" with "Enable", since --demangle option
enables symbol demangling, not disable it.
perf probe has --demangle and --no-demangle options,
but the command-line help (--help) shows only --demangle
option. So it should explain about --demangle.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/perf/builtin-probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 23d6e7f0..2d3577d 100644
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


