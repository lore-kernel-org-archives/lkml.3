Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab3EaLXu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:23:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab3EaLXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:23:44 -0400
Date: Fri, 31 May 2013 04:22:55 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-s7476m0irq0naxkzd9iekbr3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com, wcohen@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, wcohen@redhat.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf archive: Fix typo on Documentation
Git-Commit-ID: bc8b8c0d6ae55c3d11c381cfd6339c7557bbab44
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

Commit-ID:  bc8b8c0d6ae55c3d11c381cfd6339c7557bbab44
Gitweb:     http://git.kernel.org/tip/bc8b8c0d6ae55c3d11c381cfd6339c7557bbab44
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 4 Apr 2013 12:41:22 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:23:55 +0300

perf archive: Fix typo on Documentation

It is analysis, not analisys.

Reported-by: William Cohen <wcohen@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-s7476m0irq0naxkzd9iekbr3@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-archive.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-archive.txt b/tools/perf/Documentation/perf-archive.txt
index fae174d..5032a14 100644
--- a/tools/perf/Documentation/perf-archive.txt
+++ b/tools/perf/Documentation/perf-archive.txt
@@ -13,7 +13,7 @@ SYNOPSIS
 DESCRIPTION
 -----------
 This command runs runs perf-buildid-list --with-hits, and collects the files
-with the buildids found so that analisys of perf.data contents can be possible
+with the buildids found so that analysis of perf.data contents can be possible
 on another machine.
 
 
