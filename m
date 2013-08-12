Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab3HLKTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:19:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47819 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab3HLKTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:19:35 -0400
Date: Mon, 12 Aug 2013 03:18:46 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-jurgz6myq125o1ql6lldh6f7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, thiagolcpeixoto@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, thiagolcpeixoto@gmail.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf python: Remove duplicate TID bit from mask
Git-Commit-ID: 3223565cdf856fa07024e5db7ca24e1b1b38d1db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:18:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3223565cdf856fa07024e5db7ca24e1b1b38d1db
Gitweb:     http://git.kernel.org/tip/3223565cdf856fa07024e5db7ca24e1b1b38d1db
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 1 Aug 2013 17:00:45 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:25 -0300

perf python: Remove duplicate TID bit from mask

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thiago Peixoto <thiagolcpeixoto@gmail.com>
Link: http://lkml.kernel.org/n/tip-jurgz6myq125o1ql6lldh6f7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/python/twatch.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/python/twatch.py b/tools/perf/python/twatch.py
index b11cca5..2225162 100755
--- a/tools/perf/python/twatch.py
+++ b/tools/perf/python/twatch.py
@@ -21,7 +21,7 @@ def main():
 	evsel = perf.evsel(task = 1, comm = 1, mmap = 0,
 			   wakeup_events = 1, watermark = 1,
 			   sample_id_all = 1,
-			   sample_type = perf.SAMPLE_PERIOD | perf.SAMPLE_TID | perf.SAMPLE_CPU | perf.SAMPLE_TID)
+			   sample_type = perf.SAMPLE_PERIOD | perf.SAMPLE_TID | perf.SAMPLE_CPU)
 	evsel.open(cpus = cpus, threads = threads);
 	evlist = perf.evlist(cpus, threads)
 	evlist.add(evsel)
