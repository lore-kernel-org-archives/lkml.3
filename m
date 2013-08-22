Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3HVDDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 23:03:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703Ab3HVDDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 23:03:00 -0400
Date: Wed, 21 Aug 2013 23:02:42 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: akpm@linux-foundation.org, mgorman@suse.de, jiang.liu@huawei.com,
        cody@linux.vnet.ibm.com, minchan@kernel.org,
        yongjun_wei@trendmicro.com.cn, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Message-ID: <1377140562-vx0ifft7-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <CAPgLHd8+CD8iNZ4d7OJgc-jqd4ObgLnE0WmkGM5S98Q1TtTROQ@mail.gmail.com>
References: <CAPgLHd8+CD8iNZ4d7OJgc-jqd4ObgLnE0WmkGM5S98Q1TtTROQ@mail.gmail.com>
Subject: Re: [PATCH -next] mm/page_alloc.c: remove duplicated include from
 page_alloc.c
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <CAPgLHd8+CD8iNZ4d7OJgc-jqd4ObgLnE0WmkGM5S98Q1TtTROQ@mail.gmail.com>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 10:47:27AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Remove duplicated include.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  mm/page_alloc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index efb2ffa..4751901 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -60,7 +60,6 @@
>  #include <linux/page-debug-flags.h>
>  #include <linux/hugetlb.h>
>  #include <linux/sched/rt.h>
> -#include <linux/hugetlb.h>
>  
>  #include <asm/sections.h>
>  #include <asm/tlbflush.h>
> 

That's my fault. Thank you for fixing.

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
