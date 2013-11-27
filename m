Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab3K0OPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:15:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47609 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3K0OIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:08:12 -0500
Date: Wed, 27 Nov 2013 06:07:32 -0800
From: tip-bot for Nicolas Dichtel <tipbot@zytor.com>
Message-ID: <tip-96739d6e548e16d76de39d059e1e39e70c187fff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, nicolas.dichtel@6wind.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, nicolas.dichtel@6wind.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1384937428-15731-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1384937428-15731-1-git-send-email-nicolas.dichtel@6wind.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/doc: Fix generation of device-drivers
Git-Commit-ID: 96739d6e548e16d76de39d059e1e39e70c187fff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:07:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96739d6e548e16d76de39d059e1e39e70c187fff
Gitweb:     http://git.kernel.org/tip/96739d6e548e16d76de39d059e1e39e70c187fff
Author:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
AuthorDate: Wed, 20 Nov 2013 09:50:28 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 11:05:23 +0100

sched/doc: Fix generation of device-drivers

Since commit 7a6354e241d8 ("sched: Move wait.c into kernel/sched/"), the path
of this file has changed.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: jkosina@suse.cz
Cc: akpm@linux-foundation.org
Cc: linux-doc@vger.kernel.org
Cc: rob@landley.net
Cc: joe@perches.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1384937428-15731-1-git-send-email-nicolas.dichtel@6wind.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/DocBook/device-drivers.tmpl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 6c9d9d3..f517008 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -58,7 +58,7 @@
      </sect1>
      <sect1><title>Wait queues and Wake events</title>
 !Iinclude/linux/wait.h
-!Ekernel/wait.c
+!Ekernel/sched/wait.c
      </sect1>
      <sect1><title>High-resolution timers</title>
 !Iinclude/linux/ktime.h
