Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3L0LrX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 06:47:23 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34589 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397Ab3L0LrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 06:47:19 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 0/5] Sched: Some trivial typo fixes
Date: Fri, 27 Dec 2013 19:47:01 +0800
Message-Id: <1388144821-28579-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122711-0320-0000-0000-0000020F7CA9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

They were found when i review sched related src code.

Zhi Yong Wu (5):
  sched, rt: move .switched_from out of the scope of CONFIG_SMP
  sched, fair: fix the comment of move_tasks()
  sched, fair: fix the typo in select_idle_sibling()
  sched, fair: fix the comment of select_task_rq_fair()
  Documentation, sched-arch.txt: fix the incorrect syntax

 Documentation/scheduler/sched-arch.txt |    2 +-
 kernel/sched/fair.c                    |    6 +++---
 kernel/sched/rt.c                      |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

-- 
1.7.6.5

