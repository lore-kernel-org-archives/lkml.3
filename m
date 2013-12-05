Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3LEPEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 10:04:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247Ab3LEPEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 10:04:36 -0500
Date: Thu, 05 Dec 2013 10:03:51 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Message-ID: <1386255831-pmlbizbv-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386241817-5051-2-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386241817-5051-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386241817-5051-2-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] sched/numa: drop idx field of task_numa_env struct
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386241817-5051-2-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 07:10:17PM +0800, Wanpeng Li wrote:
> Drop unused idx field of task_numa_env struct.
> 
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  kernel/sched/fair.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index fd773ad..ea3fd1e 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1037,7 +1037,7 @@ struct task_numa_env {
>  
>  	struct numa_stats src_stats, dst_stats;
>  
> -	int imbalance_pct, idx;
> +	int imbalance_pct;
>  
>  	struct task_struct *best_task;
>  	long best_imp;
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
