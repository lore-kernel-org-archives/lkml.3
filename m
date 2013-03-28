Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab3C1En7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 00:43:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:52677 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3C1En6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 00:43:58 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-5c-5153ca8c47f1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Wei Yongjun'" <weiyj.lk@gmail.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'Rafael J. Wysocki'" <rjw@sisk.pl>, "'Jens Axboe'" <axboe@kernel.dk>,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <CAPgLHd87a0=e8pX4YRwpxzxk1=YgcVimjxTFnpJKH8wRs1WfjQ@mail.gmail.com>
In-reply-to: <CAPgLHd87a0=e8pX4YRwpxzxk1=YgcVimjxTFnpJKH8wRs1WfjQ@mail.gmail.com>
Subject: Re: [PATCH -next] mg_disk: fix error return code in mg_probe()
Date: Thu, 28 Mar 2013 13:43:56 +0900
Message-id: <000501ce2b6e$db4963e0$91dc2ba0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4rbS+UQ91DapY3TJy4u50o6kiv9AAAKDeA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zY92eU8GBBq39xhZz1q9hs1h9t5/N
	4vLCS6wWl3fNYbPoX9jLZPHh0lFmi53rOtkd2D12zrrL7nH5bKnHiRm/WTz6tqxi9Hi0uIXR
	Y+m9o4wenzfJBbBHcdmkpOZklqUW6dslcGXsOLuIreA8R8WEWZ8ZGxj/sHUxcnJICJhIvOtd
	wgxhi0lcuLceLC4ksIxR4vzzcJiamVd3snQxcgHFpzNK3D8+nQmi6BejRPsKORCbTUBN4suX
	w+wgtohAqMTNB/dYQRqYBdYwSnRf6wJq4ABqCJB48DYVpIZTIFhi5ecpYHOEBdwlNs+/A2az
	CKhKvL02mR2knFfAVuLSFBWQMK+AoMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlBimXEFCXePRX
	F+ICI4lTt4+yQpSISOx78Y4R5BoJgb/sEpO6lrJArBKQ+Db5EAtEr6zEpgPQYJCUOLjiBssE
	RolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IWK84Mbe4NC9dLzk/dxMjJJb7dzDePWB9
	iDEZaP1EZinR5HxgKsgriTc0NjOyMDUxNTYytzQjTVhJnFetxTpQSCA9sSQ1OzW1ILUovqg0
	J7X4ECMTB6dUA2OC6/mYl2nJk097Xpjk0JdwoGGmdtrNjtLPhr/ObD6y28Kh/S9zksSy/i0b
	ns5l/sLWsy7m97T9a9M+61aX7Yr++milpwqrQ+3fqpuqQZWr3zcmH1yQfP/A0RO6ZWw7tv22
	875x89XiE53ePAorDkdXMS77tU91YaUoW9W7E3Js7DfyurbE6B1XYinOSDTUYi4qTgQAlB3n
	2/sCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jQd2eU8GBBktv6VnMWb+GzWL13X42
	i8sLL7FaXN41h82if2Evk8WHS0eZLXau62R3YPfYOesuu8fls6UeJ2b8ZvHo27KK0ePR4hZG
	j6X3jjJ6fN4kF8Ae1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
	5OIToOuWmQN0kJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY8fZRWwF
	5zkqJsz6zNjA+Ieti5GTQ0LARGLm1Z0sELaYxIV764HiXBxCAtMZJe4fn84EkhAS+MUo0b5C
	DsRmE1CT+PLlMDuILSIQKnHzwT1WkAZmgTWMEt3XuoAaOIAaAiQevE0FqeEUCJZY+XkK2Bxh
	AXeJzfPvgNksAqoSb69NZgcp5xWwlbg0RQUkzCsgKPFj8j2we5gFtCTW7zzOBGHLS2xe85YZ
	pFxCQF3i0V9diAuMJE7dPsoKUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjOFU8k9rBuLLB4hCjAAejEg9vhUBwoBBrYllxZe4hRgkOZiUR
	3kOdQCHelMTKqtSi/Pii0pzU4kOMyUB/TmSWEk3OB6axvJJ4Q2MTMyNLIzMLIxNzc9KElcR5
	D7RaBwoJpCeWpGanphakFsFsYeLglGpglA82/MN9soVp6ebVTmfzD651Uv2za9GzbR+jX611
	sgl9KfBqh7YA+7qgun0pJvmpYW7qrdel1in6mbY/F9/9JOBybuh5J+OeYg6hvFIvR5HypoaW
	tONTt2zKz8vgKbqu6LzyWXOMwXRR5fKS00rfRBu7p8te8LN4/WXq1p1TCpSeWE7NUPqmxFKc
	kWioxVxUnAgAcqoA1VkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 28, 2013 1:32 PM, Wei Yongjun wrote:
> 
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return a negative error code from the error handling
> case instead of 0, as returned elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

CC'ed Jens Axboe

It looks good.
Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/block/mg_disk.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
> index 532bb89..a56cfcd 100644
> --- a/drivers/block/mg_disk.c
> +++ b/drivers/block/mg_disk.c
> @@ -892,8 +892,10 @@ static int mg_probe(struct platform_device *plat_dev)
>  	gpio_direction_output(host->rst, 1);
> 
>  	/* reset out pin */
> -	if (!(prv_data->dev_attr & MG_DEV_MASK))
> +	if (!(prv_data->dev_attr & MG_DEV_MASK)) {
> +		err = -EINVAL;
>  		goto probe_err_3a;
> +	}
> 
>  	if (prv_data->dev_attr != MG_BOOT_DEV) {
>  		rsc = platform_get_resource_byname(plat_dev, IORESOURCE_IO,

