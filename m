Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987AbaCRVEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:04:41 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:53632 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757888AbaCRVEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:04:39 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tools: remove unused simple_strtoul() function
Date: Tue, 18 Mar 2014 17:05:15 -0400
Message-Id: <1395176715-4465-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.9.0.431.g014438b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moreover, the corresponding function in include/linux/kernel.h is marked
obsolete.

Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/util/include/linux/kernel.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index d8c927c..9844c31 100644
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
1.9.0.431.g014438b

