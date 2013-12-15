Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3LOQ45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 11:56:57 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48258 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab3LOQ4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 11:56:55 -0500
Date: Sun, 15 Dec 2013 17:56:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v8 1/4] sched/numa: drop
 sysctl_numa_balancing_settle_count sysctl
Message-ID: <20131215165643.GC16438@laptop.programming.kicks-ass.net>
References: <1386833006-6600-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <20131213180933.GS21999@twins.programming.kicks-ass.net>
 <20131215084110.GA4316@hacker.(null)>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131215084110.GA4316@hacker.(null)>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15, 2013 at 04:41:10PM +0800, Wanpeng Li wrote:
> Do you mean something like: 
> 
> commit 887c290e (sched/numa: Decide whether to favour task or group
> weights
> based on swap candidate relationships) drop the check against
> sysctl_numa_balancing_settle_count, this patch remove the sysctl.
> 
> Acked-by: Mel Gorman <mgorman@suse.de>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
> Changelog:
>  v7 -> v8:
>    * remove references to it in Documentation/sysctl/kernel.txt
> ---

No need to insert another --- line, just the one below the SoB,

> Documentation/sysctl/kernel.txt |    5 -----
> include/linux/sched/sysctl.h    |    1 -
> kernel/sched/fair.c             |    9 ---------
> kernel/sysctl.c                 |    7 -------
> 4 files changed, 0 insertions(+), 22 deletions(-)

Everything between --- and the patch proper (usually started with an
Index line or other diff syntax thingy), including this diffstat you
have, will be made to disappear.

But yes indeed. The Changelog should describe the patch as is, and the
differences between this and the previous version are relevant only to
the reviewer who saw the previous version too. But once we commit the
patch, the previous version ceases to exist (in the commit history) and
therefore such comments loose their intrinsic meaning and should go away
too.
