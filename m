Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3FNGSc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 02:18:32 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:54778 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320Ab3FNGSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 02:18:31 -0400
From: Lei Wen <leiwen@marvell.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        <mingo@redhat.com>, <leiwen@marvell.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] small fix for fix_small_imbalance
Date: Fri, 14 Jun 2013 14:14:17 +0800
Message-ID: <1371190459-10365-1-git-send-email-leiwen@marvell.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is two patches which correct the scale usage in the fix_small_balance,
and give out comment over when fix_small_imbalance would cause load change.

Lei Wen (2):
  sched: reduce calculation effort in fix_small_imbalance
  sched: scale the busy and this queue's per-task load before compare

 kernel/sched/fair.c |   37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

-- 
1.7.10.4

