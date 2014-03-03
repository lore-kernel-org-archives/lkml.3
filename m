Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaCCOj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 09:39:57 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:35885 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbaCCOj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 09:39:56 -0500
Date: Mon, 3 Mar 2014 08:39:48 -0600
From: Seth Jennings <sjennings@variantweb.net>
To: SeongJae Park <sj38.park@gmail.com>
Cc: sjenning@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: zswap: remove unnecessary parentheses
Message-ID: <20140303143948.GA3362@cerebellum.variantweb.net>
References: <1393839476-24989-1-git-send-email-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393839476-24989-1-git-send-email-sj38.park@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2014 at 06:37:56PM +0900, SeongJae Park wrote:
> Fix following trivial checkpatch error:
> 	ERROR: return is not a function, parentheses are not required
> 
> Signed-off-by: SeongJae Park <sj38.park@gmail.com>

Thanks for the cleanup.
Might copy trivial@kernel.org on patches like this in the future.

Acked-by: Seth Jennings <sjennings@variantweb.net>

> ---
>  mm/zswap.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index c0c9b7c..34b75cc 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -204,7 +204,7 @@ static struct kmem_cache *zswap_entry_cache;
>  static int zswap_entry_cache_create(void)
>  {
>  	zswap_entry_cache = KMEM_CACHE(zswap_entry, 0);
> -	return (zswap_entry_cache == NULL);
> +	return zswap_entry_cache == NULL;
>  }
>  
>  static void zswap_entry_cache_destory(void)
> @@ -408,8 +408,8 @@ cleanup:
>  **********************************/
>  static bool zswap_is_full(void)
>  {
> -	return (totalram_pages * zswap_max_pool_percent / 100 <
> -		zswap_pool_pages);
> +	return totalram_pages * zswap_max_pool_percent / 100 <
> +		zswap_pool_pages;
>  }
>  
>  /*********************************
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
