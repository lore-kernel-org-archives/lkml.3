Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab3HRIZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:25:59 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:58145 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380Ab3HRIZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:25:55 -0400
From: Lei Wen <leiwen@marvell.com>
To: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/8] sched: fixes for the nr_running usage
Date: Sun, 18 Aug 2013 16:25:14 +0800
Message-ID: <1376814322-7320-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it is different for the nr_running and h_nr_running in its
presenting meaning, we should take care of their usage in the scheduler.

Lei Wen (8):
  sched: change load balance number to h_nr_running of run queue
  sched: change cpu_avg_load_per_task using h_nr_running
  sched: change update_rq_runnable_avg using h_nr_running
  sched: change pick_next_task_fair to h_nr_running
  sched: change update_sg_lb_stats to h_nr_running
  sched: change find_busiest_queue to h_nr_running
  sched: change active_load_balance_cpu_stop to use h_nr_running
  sched: document the difference between nr_running and h_nr_running

 kernel/sched/fair.c  |   23 +++++++++++++----------
 kernel/sched/sched.h |    6 ++++++
 2 files changed, 19 insertions(+), 10 deletions(-)

-- 
1.7.5.4

