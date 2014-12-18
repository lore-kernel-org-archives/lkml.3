Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaLRBsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 20:48:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:39327 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbaLRBsu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 20:48:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,597,1413270000"; 
   d="scan'208";a="639387913"
Date: Thu, 18 Dec 2014 09:28:44 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Juri Lelli <juri.lelli@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpeng.li@linux.intel.com>
Subject: Re: [PATCH v6 0/7] sched: support dl task migration during cpu
 hotplug and other fixes
Message-ID: <20141218012843.GA4685@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416962647-76792-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Juri,
On Wed, Nov 26, 2014 at 08:44:00AM +0800, Wanpeng Li wrote:
>I collect recent send out patches to one patchset in order to get review easily.
>
>For 7/7 I will remove rd->span related modification if Pang's effort merged.
>https://lkml.org/lkml/2014/11/17/443
>
>Wanpeng Li (7):
>  sched/deadline: fix start high-res preemption tick for a non-leftmost task
>  sched/deadline: fix rt runtime corrupt when dl refuse a smaller bandwidth
>  sched/deadline: fix dl entity is still mark yield after replenishing
>  sched/deadline: reduce overhead if there are no scheduling parameters changed
>  sched/fair: fix idle balance when remaining tasks are all non-CFS tasks
>  sched: fix start hrtick for short schedule slices on UP
>  sched/deadline: support dl task migration during cpu hotplug
>
> kernel/sched/core.c     | 27 +++++++++++++++++----
> kernel/sched/deadline.c | 62 +++++++++++++++++++++++++++++++++++++++++++++----
> kernel/sched/fair.c     |  2 +-
> kernel/sched/sched.h    |  3 ++-
> 4 files changed, 84 insertions(+), 10 deletions(-)
>
>-- 
>1.9.1
