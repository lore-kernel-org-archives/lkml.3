Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3EaMUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 08:20:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57530 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034Ab3EaMUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 08:20:46 -0400
Date: Fri, 31 May 2013 05:20:22 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-0ac129e008971aea9f6b17cb77a12e2ffc9dc80c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1369394201-20044-6-git-send-email-jolsa@redhat.com>
References: <1369394201-20044-6-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove cwdlen from struct perf_session
Git-Commit-ID: 0ac129e008971aea9f6b17cb77a12e2ffc9dc80c
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

Commit-ID:  0ac129e008971aea9f6b17cb77a12e2ffc9dc80c
Gitweb:     http://git.kernel.org/tip/0ac129e008971aea9f6b17cb77a12e2ffc9dc80c
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 24 May 2013 13:16:41 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 May 2013 15:24:04 +0300

perf tools: Remove cwdlen from struct perf_session

Removing cwdlen from struct perf_session as it's no longer used.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369394201-20044-6-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 6b51d47..f3b235e 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -37,7 +37,6 @@ struct perf_session {
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
-	int			cwdlen;
 	char			*cwd;
 	struct ordered_samples	ordered_samples;
 	char			filename[1];
