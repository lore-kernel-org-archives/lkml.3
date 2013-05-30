Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934252Ab3E3QQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:16:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50744 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934246Ab3E3QCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/66] perf archive: Fix typo on Documentation
Date: Thu, 30 May 2013 19:00:42 +0300
Message-Id: <1369929699-8724-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 
 
-- 
1.8.1.4

