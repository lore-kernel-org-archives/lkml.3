Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935076AbaGPTUW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:20:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754969AbaGPTUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:20:09 -0400
Date: Wed, 16 Jul 2014 12:18:56 -0700
From: tip-bot for Paul Bolle <tipbot@zytor.com>
Message-ID: <tip-d3f44fbabe55132832e152606365adb640296378@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, pebolle@tiscali.nl, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, jkosina@suse.cz,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, pebolle@tiscali.nl,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        jkosina@suse.cz
In-Reply-To: <1404138749.2978.6.camel@x41>
References: <1404138749.2978.6.camel@x41>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Remove unused variable "polling"
Git-Commit-ID: d3f44fbabe55132832e152606365adb640296378
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

Commit-ID:  d3f44fbabe55132832e152606365adb640296378
Gitweb:     http://git.kernel.org/tip/d3f44fbabe55132832e152606365adb640296378
Author:     Paul Bolle <pebolle@tiscali.nl>
AuthorDate: Mon, 30 Jun 2014 16:32:29 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 12:58:47 +0200

x86: Remove unused variable "polling"

Compile tested. "polling" is unused since commit f80c5b39b80a
("sched/idle, x86: Switch from TS_POLLING to TIF_POLLING_NRFLAG").

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Kosina <jkosina@suse.cz>
Link: http://lkml.kernel.org/r/1404138749.2978.6.camel@x41
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apm_32.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index f3a1f04..5848744 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -841,7 +841,6 @@ static int apm_do_idle(void)
 	u32 eax;
 	u8 ret = 0;
 	int idled = 0;
-	int polling;
 	int err = 0;
 
 	if (!need_resched()) {
