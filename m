Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaANQk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:40:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52708 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaANQjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:39:43 -0500
Date: Tue, 14 Jan 2014 08:39:26 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-8f3dd2b096c348033e55d4a4fb8c0f672559657e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1389132847-31982-1-git-send-email-andi@firstfloor.org>
References: <1389132847-31982-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Fix --delay option in man page
Git-Commit-ID: 8f3dd2b096c348033e55d4a4fb8c0f672559657e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 08:39:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f3dd2b096c348033e55d4a4fb8c0f672559657e
Gitweb:     http://git.kernel.org/tip/8f3dd2b096c348033e55d4a4fb8c0f672559657e
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 7 Jan 2014 14:14:06 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Jan 2014 10:06:24 -0300

perf stat: Fix --delay option in man page

The --delay option was documented as --initial-delay in the manpage. Fix this.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1389132847-31982-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-stat.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 80c7da6..29ee857 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -133,7 +133,7 @@ use --per-core in addition to -a. (system-wide).  The output includes the
 core number and the number of online logical processors on that physical processor.
 
 -D msecs::
---initial-delay msecs::
+--delay msecs::
 After starting the program, wait msecs before measuring. This is useful to
 filter out the startup phase of the program, which is often very different.
 
