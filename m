Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399AbaLAAbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 19:31:43 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:35453 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaLAAbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 19:31:42 -0500
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
Date: Mon, 1 Dec 2014 09:31:56 +0900
From: Minchan Kim <minchan@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Valentin Rothberg <valentinrothberg@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next-20141127] mm: Fix comment typo
 "CONFIG_TRANSPARNTE_HUGE"
Message-ID: <20141201003156.GD11340@bbox>
References: <1417093031.29407.102.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1417093031.29407.102.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Nov 27, 2014 at 01:57:11PM +0100, Paul Bolle wrote:
> The commit "mm: don't split THP page when syscall is called" added a
> reference to CONFIG_TRANSPARNTE_HUGE in a comment. Use
> CONFIG_TRANSPARENT_HUGEPAGE instead, as was probably intended.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Acked-by: Minchan Kim <minchan@kernel.org>

Thanks!

> ---
> Compile tested.
> 
> If commit "mm: don't split THP page when syscall is called" is not yet
> set in stone, I would prefer if this trivial fix would be squashed into
> that commit.

Hope so. :)

> 
>  mm/rmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index d2a6e136b08d..95d394bbb6ab 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -708,7 +708,7 @@ static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
>  		/*
>  		 * Use pmd_freeable instead of raw pmd_dirty because in some
>  		 * of architecture, pmd_dirty is not defined unless
> -		 * CONFIG_TRANSPARNTE_HUGE is enabled
> +		 * CONFIG_TRANSPARENT_HUGEPAGE is enabled
>  		 */
>  		if (!pmd_freeable(*pmd))
>  			dirty++;
> -- 
> 1.9.3
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
