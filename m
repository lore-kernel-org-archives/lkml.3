Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3EXLSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:18:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3EXLRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:17:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 5/5] perf tools: Remove cwdlen from struct perf_session
Date: Fri, 24 May 2013 13:16:41 +0200
Message-Id: <1369394201-20044-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
References: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing cwdlen from struct perf_session as it's
no longer used.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
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
-- 
1.7.11.7

