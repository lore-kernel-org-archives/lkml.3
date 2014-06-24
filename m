Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaFXGCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:02:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaFXGCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:02:40 -0400
Date: Tue, 24 Jun 2014 01:59:50 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Andi Kleen <ak@linux.intel.com>,
        Vladimir Cernov <gg.kaspersky@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: update the description for madvise_remove
Message-ID: <20140624055950.GA12855@nhori.redhat.com>
References: <53A9116B.9030004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A9116B.9030004@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 01:49:31PM +0800, Wang Sheng-Hui wrote:
> 
> Currently, we have more filesystems supporting fallocate, e.g
> ext4/btrfs. Remove the outdated comment for madvise_remove.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>

Looks good to me.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

> ---
>  mm/madvise.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index a402f8f..0938b30 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -292,9 +292,6 @@ static long madvise_dontneed(struct vm_area_struct *vma,
>  /*
>   * Application wants to free up the pages and associated backing store.
>   * This is effectively punching a hole into the middle of a file.
> - *
> - * NOTE: Currently, only shmfs/tmpfs is supported for this operation.
> - * Other filesystems return -ENOSYS.
>   */
>  static long madvise_remove(struct vm_area_struct *vma,
>                                 struct vm_area_struct **prev,
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 
