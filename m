Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab3FQNB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 09:01:56 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:60213 "EHLO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755240Ab3FQNBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 09:01:55 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/3] small fix for scale usage
Date: Mon, 17 Jun 2013 21:00:21 +0800
Message-ID: <1371474024-19787-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are three patches which correct scale usage in both fix_small_imbalance
and update_sg_lb_stats.

And give out comment over when fix_small_imbalance would cause load change.

V2: fix scale usage for update_sg_lb_stats

Lei Wen (3):
  sched: reduce calculation effort in fix_small_imbalance
  sched: scale the busy and this queue's per-task load before compare
  sched: scale cpu load for judgment of group imbalance

 kernel/sched/fair.c |   56 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 22 deletions(-)

-- 
1.7.10.4

