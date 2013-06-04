Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758811Ab3FDGWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:22:45 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:34391 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3FDGWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:22:42 -0400
Message-ID: <51AD87A8.6080608@linux.vnet.ibm.com>
Date: Tue, 04 Jun 2013 14:22:32 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 0/3] sched: code refine/clean for cfs-bandwidth
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060406-3864-0000-0000-00000871219B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Code refine and clean patch set.

Michael Wang (3):
	[PATCH 1/3] sched: don't repeat the initialization in sched_init()
	[PATCH 2/3] sched: code refine in unthrottle_cfs_rq()
	[PATCH 3/3] sched: remove the useless declaration in kernel/sched/fair.c

--- 
 b/kernel/sched/core.c |   46 +++++++++++++++++++++++++---------------------
 b/kernel/sched/fair.c |    2 +-
 kernel/sched/fair.c   |    4 ----
 3 files changed, 26 insertions(+), 26 deletions(-)

