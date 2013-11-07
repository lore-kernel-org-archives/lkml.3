Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3KGSSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 13:18:16 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:56325 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab3KGSQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 13:16:41 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/6] trivial: fix spelling in CONTEXT_TRACKING_FORCE help text
Date: Thu,  7 Nov 2013 19:16:27 +0100
Message-Id: <1383848191-30807-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383848191-30807-1-git-send-email-fweisbec@gmail.com>
References: <1383848191-30807-1-git-send-email-fweisbec@gmail.com>
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
index 841e79c..3a838e5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -546,7 +546,7 @@ config CONTEXT_TRACKING_FORCE
 	  dynticks subsystem by forcing the context tracking on all
 	  CPUs in the system.
 
-	  Say Y only if you're working on the developpement of an
+	  Say Y only if you're working on the development of an
 	  architecture backend for the context tracking.
 
 	  Say N otherwise, this option brings an overhead that you
-- 
1.8.3.1

