Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaJOKGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:06:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54496 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaJOKGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:06:08 -0400
Date: Wed, 15 Oct 2014 03:05:08 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-94t3jvw4tmzrq3dnovvpl65e@git.kernel.org>
Cc: namhyung@kernel.org, bp@suse.de, mingo@kernel.org, jean.pihet@linaro.org,
        adrian.hunter@intel.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        acme@redhat.com, efault@gmx.de, dsahern@gmail.com, hpa@zytor.com,
        dzickus@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        paulus@samba.org
Reply-To: efault@gmx.de, dsahern@gmail.com, hpa@zytor.com, dzickus@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, paulus@samba.org,
        mingo@kernel.org, bp@suse.de, namhyung@kernel.org,
        adrian.hunter@intel.com, peterz@infradead.org, jean.pihet@linaro.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        jolsa@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel: Add missing 'target'
  struct forward declaration
Git-Commit-ID: 80b2210c623dc47e0847816989dd647738e4fb94
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

Commit-ID:  80b2210c623dc47e0847816989dd647738e4fb94
Gitweb:     http://git.kernel.org/tip/80b2210c623dc47e0847816989dd647738e4fb94
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 13 Oct 2014 10:29:50 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:32:54 -0300

perf evsel: Add missing 'target' struct forward declaration

We use it in evsel.h but were getting it indirectly, fix it.

Noticed while working on having evsel.h usable by rasd.c.

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
Link: http://lkml.kernel.org/n/tip-94t3jvw4tmzrq3dnovvpl65e@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index fee9274..5c80cf0 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -99,6 +99,7 @@ union u64_swap {
 };
 
 struct cpu_map;
+struct target;
 struct thread_map;
 struct perf_evlist;
 struct record_opts;
