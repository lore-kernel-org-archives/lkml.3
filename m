Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab3K3Myc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:54:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59817 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3K3My0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:54:26 -0500
Date: Sat, 30 Nov 2013 04:53:46 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-jomi6mjv5zi9vsn4vmih5xps@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, stfomichev@yandex-team.ru, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, stfomichev@yandex-team.ru, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf timechart:
  Remove some needless struct forward declarations
Git-Commit-ID: 6e53ad9ff65226f79d5888452992222284c7e4d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:53:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e53ad9ff65226f79d5888452992222284c7e4d4
Gitweb:     http://git.kernel.org/tip/6e53ad9ff65226f79d5888452992222284c7e4d4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 27 Nov 2013 16:29:50 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 16:29:50 -0300

perf timechart: Remove some needless struct forward declarations

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jomi6mjv5zi9vsn4vmih5xps@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-timechart.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 436cb5f..c246f02 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -55,14 +55,8 @@ static bool		tasks_only;
 static bool		with_backtrace;
 
 
-struct per_pid;
 struct per_pidcomm;
-
 struct cpu_sample;
-struct power_event;
-struct wake_event;
-
-struct sample_wrapper;
 
 /*
  * Datastructure layout:
@@ -155,7 +149,6 @@ struct wake_event {
 static struct power_event    *power_events;
 static struct wake_event     *wake_events;
 
-struct process_filter;
 struct process_filter {
 	char			*name;
 	int			pid;
