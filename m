Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758206AbaCRVdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:33:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44422 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039AbaCRV0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:26:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/13] perf tools: Remove unused simple_strtoul() function
Date: Tue, 18 Mar 2014 18:26:05 -0300
Message-Id: <1395177965-8879-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1395177965-8879-1-git-send-email-acme@infradead.org>
References: <1395177965-8879-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Moreover, the corresponding function in include/linux/kernel.h is marked
obsolete.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1395176715-4465-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/include/linux/kernel.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index d8c927c868ee..9844c31b7c2b 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -94,12 +94,6 @@ static inline int scnprintf(char * buf, size_t size, const char * fmt, ...)
 	return (i >= ssize) ? (ssize - 1) : i;
 }
 
-static inline unsigned long
-simple_strtoul(const char *nptr, char **endptr, int base)
-{
-	return strtoul(nptr, endptr, base);
-}
-
 int eprintf(int level,
 	    const char *fmt, ...) __attribute__((format(printf, 2, 3)));
 
-- 
1.8.1.4

