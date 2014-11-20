Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046AbaKTHkw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:40:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43916 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbaKTHku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:40:50 -0500
Date: Wed, 19 Nov 2014 23:40:16 -0800
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-4b34f19b66ad29f10af90ad396131adbd16d737f@git.kernel.org>
Cc: acme@redhat.com, jolsa@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com,
        namhyung@gmail.com, eranian@google.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, paulus@samba.org,
        linux-kernel@vger.kernel.org
Reply-To: dsahern@gmail.com, adrian.hunter@intel.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, jolsa@redhat.com,
        hpa@zytor.com, eranian@google.com, fweisbec@gmail.com,
        namhyung@gmail.com
In-Reply-To: <1415715423-15563-3-git-send-email-adrian.hunter@intel.com>
References: <1415715423-15563-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add perf-read-vdso32 and perf-read-vdsox32 to .gitignore
Git-Commit-ID: 4b34f19b66ad29f10af90ad396131adbd16d737f
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

Commit-ID:  4b34f19b66ad29f10af90ad396131adbd16d737f
Gitweb:     http://git.kernel.org/tip/4b34f19b66ad29f10af90ad396131adbd16d737f
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 11 Nov 2014 16:16:40 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:34:24 -0300

perf tools: Add perf-read-vdso32 and perf-read-vdsox32 to .gitignore

Recently added executables Add perf-read-vdso32 and perf-read-vdsox32
need to be added to .gitignore.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1415715423-15563-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/.gitignore | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 717221e..40399c3 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -2,6 +2,8 @@ PERF-CFLAGS
 PERF-GUI-VARS
 PERF-VERSION-FILE
 perf
+perf-read-vdso32
+perf-read-vdsox32
 perf-help
 perf-record
 perf-report
