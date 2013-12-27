Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab3L0Llk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 06:41:40 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44197 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab3L0Llg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 06:41:36 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 5/5] Documentation, sched-arch.txt: fix the incorrect syntax
Date: Fri, 27 Dec 2013 19:41:04 +0800
Message-Id: <1388144464-28458-6-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
References: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122711-7182-0000-0000-0000096FC62E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 Documentation/scheduler/sched-arch.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/scheduler/sched-arch.txt b/Documentation/scheduler/sched-arch.txt
index 9290de7..0a7d252 100644
--- a/Documentation/scheduler/sched-arch.txt
+++ b/Documentation/scheduler/sched-arch.txt
@@ -21,7 +21,7 @@ CPU idle
 ========
 Your cpu_idle routines need to obey the following rules:
 
-1. Preempt should now disabled over idle routines. Should only
+1. Preempt should be now disabled over idle routines. Should only
    be enabled to call schedule() then disabled again.
 
 2. need_resched/TIF_NEED_RESCHED is only ever set, and will never
-- 
1.7.6.5

