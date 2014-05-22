Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaEVGBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:01:25 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:30645 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaEVGBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:01:24 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5d-537d92ad9dda
Message-id: <537D92AE.2030105@samsung.com>
Date: Thu, 22 May 2014 08:01:18 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Gioh Kim <gioh.kim@lge.com>, rientjes@google.com, mina86@mina86.com,
        linux-kernel@vger.kernel.org
Cc: gunho.lee@lge.com, gurugio@gmail.com
Subject: Re: [PATCH] drivers/base/dma-contiguous.c: erratum of dev_get_cma_area
References: <1400733097-1176-1-git-send-email-gioh.kim@lge.com>
In-reply-to: <1400733097-1176-1-git-send-email-gioh.kim@lge.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t/xK7prJ9UGG+x7qW/xrOkLo8WFaQuZ
	LSYf/shkcXnXHDaLBcdbWC3almxkcmDz2DnrLrvHgk2lHl1vrzB5rPvzisnj8ya5ANYoLpuU
	1JzMstQifbsErow9EysK/rJX7P7xgaWBcSdbFyMnh4SAicTny79ZIGwxiQv31gPFuTiEBJYy
	Svzp6WYESQgJfGKUmPtLAcTmFdCS6Dz2HSzOIqAqseX7YWYQm03AUKLrbRfYUFGBGIndnxcy
	QtQLSvyYfA9sgYhAusTTfTfAbGYBDYmm1z1MILawgL/E4/MtTBC77CXW370GNpNTwEHi3tx7
	TBD1ZhKPWtYxQ9jyEpvXvGWewCgwC8mKWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9d
	Lzk/dxMjJKy/7GBcfMzqEKMAB6MSD6/A1epgIdbEsuLK3EOMEhzMSiK822pqg4V4UxIrq1KL
	8uOLSnNSiw8xMnFwSjUwqvAYPj0nfX2bYLjUUW7P+tpTtstTZ8z55TPLeO7HarEci60PE89u
	q3BMsWTvXhux7dOygLIna+1mPcs4N2OhYq6L44QbP3u49m+M4dfa+TJ7pjbLvRvrFba9rL2o
	Fr09YVbzdycZnt9blvXszRH7d9TlkkzGutq1/PdDzz09/eXUux/fTaZtCFZiKc5INNRiLipO
	BAAlaPgiSQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-05-22 06:31, Gioh Kim wrote:
> fix erratum get_dev_cma_area into dev_get_cma_area
>
> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
> ---
>   drivers/base/dma-contiguous.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> index b056661..6343f25 100644
> --- a/drivers/base/dma-contiguous.c
> +++ b/drivers/base/dma-contiguous.c
> @@ -291,7 +291,7 @@ err:
>    *
>    * This function allocates memory buffer for specified device. It uses
>    * device specific contiguous memory area if available or the default
> - * global one. Requires architecture specific get_dev_cma_area() helper
> + * global one. Requires architecture specific dev_get_cma_area() helper
>    * function.
>    */
>   struct page *dma_alloc_from_contiguous(struct device *dev, int count,

Thanks for this small fix. I've applied it to my tree.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

