Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3LJUfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:35:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321Ab3LJUf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:35:29 -0500
Date: Tue, 10 Dec 2013 15:35:01 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Message-ID: <1386707701-qoyirqe1-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386667175-19952-6-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386667175-19952-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386667175-19952-6-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 06/12] sched/numa: make numamigrate_update_ratelimit
 static
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386667175-19952-6-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 05:19:29PM +0800, Wanpeng Li wrote:
> Make numamigrate_update_ratelimit static.
> 
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/migrate.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 7ad81e0..b1b6663 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1592,7 +1592,8 @@ bool migrate_ratelimited(int node)
>  }
>  
>  /* Returns true if the node is migrate rate-limited after the update */
> -bool numamigrate_update_ratelimit(pg_data_t *pgdat, unsigned long nr_pages)
> +static bool numamigrate_update_ratelimit(pg_data_t *pgdat,
> +						unsigned long nr_pages)
>  {
>  	bool rate_limited = false;
>  
> -- 
> 1.7.7.6
> 
