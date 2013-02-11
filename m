Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab3BKMgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:36:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab3BKMgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:36:46 -0500
Date: Mon, 11 Feb 2013 04:34:53 -0800
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-993db4b45fd99949d8f6e004a7744b523dca473a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        williams@redhat.com, peterz@infradead.org, michael@ellerman.id.au,
        rostedt@goodmis.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, williams@redhat.com, michael@ellerman.id.au,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130207094707.7b9f825f@riff.lan>
References: <20130207094707.7b9f825f@riff.lan>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, powerpc:
  Fix sched.h split-up build failure
Git-Commit-ID: 993db4b45fd99949d8f6e004a7744b523dca473a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:34:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  993db4b45fd99949d8f6e004a7744b523dca473a
Gitweb:     http://git.kernel.org/tip/993db4b45fd99949d8f6e004a7744b523dca473a
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Mon, 11 Feb 2013 10:45:33 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:45:33 +0100

sched, powerpc: Fix sched.h split-up build failure

Fix PowerPC/Cell build fallout from:

  8bd75c77b7c6 sched/rt: Move rt specific bits into new header file

Reported-by: Michael Ellerman <michael@ellerman.id.au>
Cc: Clark Williams <williams@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20130207094707.7b9f825f@riff.lan
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/powerpc/platforms/cell/spufs/sched.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
index 25db92a..4931838 100644
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -24,6 +24,7 @@
 
 #include <linux/errno.h>
 #include <linux/sched.h>
+#include <linux/sched/rt.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
