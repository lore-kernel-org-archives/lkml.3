Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432Ab3HLKTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:19:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47812 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab3HLKTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:19:33 -0400
Date: Mon, 12 Aug 2013 03:18:36 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-zt68gijvvoe8gd7kmclo43si@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Beautify 'connect' result
Git-Commit-ID: a14bb860a38ff5b4aa3db20f251fef43e447a7c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:18:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a14bb860a38ff5b4aa3db20f251fef43e447a7c9
Gitweb:     http://git.kernel.org/tip/a14bb860a38ff5b4aa3db20f251fef43e447a7c9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 30 Jul 2013 16:38:23 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:25 -0300

perf trace: Beautify 'connect' result

It is an errno, so print an error string.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-zt68gijvvoe8gd7kmclo43si@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0e4b67f..da7ae01 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -18,6 +18,7 @@ static struct syscall_fmt {
 } syscall_fmts[] = {
 	{ .name	    = "access",	    .errmsg = true, },
 	{ .name	    = "arch_prctl", .errmsg = true, .alias = "prctl", },
+	{ .name	    = "connect",    .errmsg = true, },
 	{ .name	    = "fstat",	    .errmsg = true, .alias = "newfstat", },
 	{ .name	    = "fstatat",    .errmsg = true, .alias = "newfstatat", },
 	{ .name	    = "futex",	    .errmsg = true, },
