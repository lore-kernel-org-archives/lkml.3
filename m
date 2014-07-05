Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbaGEKsE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:48:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760844AbaGEKrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:47:48 -0400
Date: Sat, 5 Jul 2014 03:46:55 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-985c8dcbe15ddd8a1b98dc6b9c6403cb5d7012ab@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, peterz@infradead.org, acme@kernel.org,
        namhyung@kernel.org, jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1403598026-2310-1-git-send-email-jolsa@kernel.org>
References: <1403598026-2310-1-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Make perf_event_init_context()
  function static
Git-Commit-ID: 985c8dcbe15ddd8a1b98dc6b9c6403cb5d7012ab
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

Commit-ID:  985c8dcbe15ddd8a1b98dc6b9c6403cb5d7012ab
Gitweb:     http://git.kernel.org/tip/985c8dcbe15ddd8a1b98dc6b9c6403cb5d7012ab
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 24 Jun 2014 10:20:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:21:52 +0200

perf: Make perf_event_init_context() function static

Leftover from '8dc85d5 perf: Multiple task contexts'.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1403598026-2310-1-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a33d9a2b..67e3b9c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7776,7 +7776,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
 /*
  * Initialize the perf_event context in task_struct
  */
-int perf_event_init_context(struct task_struct *child, int ctxn)
+static int perf_event_init_context(struct task_struct *child, int ctxn)
 {
 	struct perf_event_context *child_ctx, *parent_ctx;
 	struct perf_event_context *cloned_ctx;
