Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3LCOik (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:38:40 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:50612 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3LCOig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:38:36 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/6] trivial: fix spelling in CONTEXT_TRACKING_FORCE help text
Date: Tue,  3 Dec 2013 15:38:22 +0100
Message-Id: <1386081506-24358-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
References: <1386081506-24358-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index 79383d3..12d61f8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -532,7 +532,7 @@ config CONTEXT_TRACKING_FORCE
 	  dynticks subsystem by forcing the context tracking on all
 	  CPUs in the system.
 
-	  Say Y only if you're working on the developpement of an
+	  Say Y only if you're working on the development of an
 	  architecture backend for the context tracking.
 
 	  Say N otherwise, this option brings an overhead that you
-- 
1.8.3.1

