Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaJALbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:31:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:1140 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbaJALbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:31:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,631,1406617200"; 
   d="scan'208";a="581813583"
Message-ID: <1412163094.3126.0.camel@linux.intel.com>
Subject: Re: [PATCH] MM: dmapool: Fixed a brace coding style issue
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Paul McQuade <paulmcquad@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof =?UTF-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        jiri Kosina <jkosina@suse.cz>, Hiroshige Sato <sato.vintage@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 01 Oct 2014 14:31:34 +0300
In-Reply-To: <542B176E.6000007@gmail.com>
References: <542B176E.6000007@gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 21:49 +0100, Paul McQuade wrote:
> From 33890970bfffc2bd64b307c41e5c1c92aaba8a2e Mon Sep 17 00:00:00 2001
> From: Paul McQuade <paulmcquad@gmail.com>
> Date: Tue, 30 Sep 2014 21:39:37 +0100
> Subject: [PATCH] MM: dmapool: Fixed a brace coding style issue
> 
> Removed 3 brace coding style for any arm of this statement
> 
> Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
> ---
>  mm/dmapool.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index ba8019b..8b3b050 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -133,28 +133,27 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
>      struct dma_pool *retval;
>      size_t allocation;
>  
> -    if (align == 0) {
> +    if (align == 0)
>          align = 1;
> -    } else if (align & (align - 1)) {
> +    else if (align & (align - 1))
>          return NULL;
> -    }
>  
> -    if (size == 0) {
> +

Extra empty line?


> +    if (size == 0)
>          return NULL;
> -    } else if (size < 4) {
> +    else if (size < 4)

>          size = 4;
> -    }
> +
>  
>      if ((size % align) != 0)
>          size = ALIGN(size, align);
>  
>      allocation = max_t(size_t, size, PAGE_SIZE);
>  
> -    if (!boundary) {
> +    if (!boundary)
>          boundary = allocation;
> -    } else if ((boundary < size) || (boundary & (boundary - 1))) {
> +    else if ((boundary < size) || (boundary & (boundary - 1)))
>          return NULL;
> -    }
>  
>      retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
>      if (!retval)


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

