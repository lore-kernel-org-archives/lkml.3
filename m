Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3LJHNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:13:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab3LJHNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:13:16 -0500
Date: Tue, 10 Dec 2013 02:12:47 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Message-ID: <1386659567-rn8hjtqh-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386483293-15354-12-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386483293-15354-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386483293-15354-12-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 12/12] sched/numa: drop local 'ret' in
 task_numa_migrate()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386483293-15354-12-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 02:14:53PM +0800, Wanpeng Li wrote:
> task_numa_migrate() has two locals called "ret". Fix it all up.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks!
Naoya

> ---
>  kernel/sched/fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index df8b677..3159ca7 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1257,7 +1257,7 @@ static int task_numa_migrate(struct task_struct *p)
>  	p->numa_scan_period = task_scan_min(p);
>  
>  	if (env.best_task == NULL) {
> -		int ret = migrate_task_to(p, env.best_cpu);
> +		ret = migrate_task_to(p, env.best_cpu);
>  		return ret;
>  	}
>  
> -- 
> 1.7.5.4
> 
