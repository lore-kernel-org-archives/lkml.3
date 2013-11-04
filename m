Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab3KDUUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:20:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49869 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3KDUUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:20:01 -0500
Date: Mon, 4 Nov 2013 12:19:03 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-cznw5tnruonyoisxu8be11bv@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        masami.hiramatsu.pt@hitachi.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix typo
Git-Commit-ID: 9ef0438a957937bf0edc26d58bce891034ff9e30
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:19:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ef0438a957937bf0edc26d58bce891034ff9e30
Gitweb:     http://git.kernel.org/tip/9ef0438a957937bf0edc26d58bce891034ff9e30
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 24 Oct 2013 17:36:31 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 10:48:02 -0300

perf probe: Fix typo

s/tyep/type/g.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-cznw5tnruonyoisxu8be11bv@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index e41b094..2200dad 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -583,7 +583,7 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 	}
 
 	if (die_find_member(&type, field->name, die_mem) == NULL) {
-		pr_warning("%s(tyep:%s) has no member %s.\n", varname,
+		pr_warning("%s(type:%s) has no member %s.\n", varname,
 			   dwarf_diename(&type), field->name);
 		return -EINVAL;
 	}
