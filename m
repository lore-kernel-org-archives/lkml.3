Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3BCTQP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 14:16:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50693 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3BCTQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 14:16:12 -0500
Date: Sun, 3 Feb 2013 11:15:46 -0800
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Message-ID: <tip-b736f48bda54ec75b7dc9306884c3843f1a78a0a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, josh@joshtriplett.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, josh@joshtriplett.org
In-Reply-To: <1353302917-13995-7-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-7-git-send-email-josh@joshtriplett.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tracing: Mark tracing_dentry_percpu() static
Git-Commit-ID: b736f48bda54ec75b7dc9306884c3843f1a78a0a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 03 Feb 2013 11:15:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b736f48bda54ec75b7dc9306884c3843f1a78a0a
Gitweb:     http://git.kernel.org/tip/b736f48bda54ec75b7dc9306884c3843f1a78a0a
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Sun, 18 Nov 2012 21:27:45 -0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 24 Jan 2013 22:03:01 -0500

tracing: Mark tracing_dentry_percpu() static

Nothing outside of kernel/trace/trace.c references tracing_dentry_percpu().

Link: http://lkml.kernel.org/r/1353302917-13995-7-git-send-email-josh@joshtriplett.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d2a6583..ca9b7df 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -4506,7 +4506,7 @@ struct dentry *tracing_init_dentry(void)
 
 static struct dentry *d_percpu;
 
-struct dentry *tracing_dentry_percpu(void)
+static struct dentry *tracing_dentry_percpu(void)
 {
 	static int once;
 	struct dentry *d_tracer;
