Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3L0LlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 06:41:20 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55349 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3L0LlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 06:41:19 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH 0/5] Sched: Some trivial typo fixes
Date: Fri, 27 Dec 2013 19:40:59 +0800
Message-Id: <1388144464-28458-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13122711-0928-0000-0000-000004DF1CCE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

*** BLURB HERE ***

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

