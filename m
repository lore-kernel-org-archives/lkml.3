Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679Ab3LFVU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:20:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab3LFVUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:20:25 -0500
Date: Fri, 06 Dec 2013 16:19:55 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Message-ID: <1386364795-hks9q1oj-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1386321136-27538-5-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1386321136-27538-1-git-send-email-liwanp@linux.vnet.ibm.com>
 <1386321136-27538-5-git-send-email-liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 5/6] sched/numa: make numamigrate_isolate_page static
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <1386321136-27538-5-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 05:12:15PM +0800, Wanpeng Li wrote:
> Make numamigrate_update_ratelimit static.

Please change this function name, too :)

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks,
Naoya Horiguchi

> Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> ---
>  mm/migrate.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index fdb70f7..7ad81e0 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1616,7 +1616,7 @@ bool numamigrate_update_ratelimit(pg_data_t *pgdat, unsigned long nr_pages)
>  	return rate_limited;
>  }
>  
> -int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
> +static int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
>  {
>  	int page_lru;
>  
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
