Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934182AbaCSNJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 09:09:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34276 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933851AbaCSNI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 09:08:57 -0400
Date: Wed, 19 Mar 2014 06:08:42 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-a51e87cb5a0fbebee15a3373d951dbf6f59a76c2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1395176715-4465-1-git-send-email-artagnon@gmail.com>
References: <1395176715-4465-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove unused simple_strtoul()
  function
Git-Commit-ID: a51e87cb5a0fbebee15a3373d951dbf6f59a76c2
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

Commit-ID:  a51e87cb5a0fbebee15a3373d951dbf6f59a76c2
Gitweb:     http://git.kernel.org/tip/a51e87cb5a0fbebee15a3373d951dbf6f59a76c2
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Tue, 18 Mar 2014 17:05:15 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 18 Mar 2014 18:17:07 -0300

perf tools: Remove unused simple_strtoul() function

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
 
