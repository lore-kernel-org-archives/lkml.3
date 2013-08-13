Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab3HMOeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 10:34:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:47904 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab3HMOeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 10:34:10 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f6f6d00000740c-66-520a43e09a34
Content-transfer-encoding: 8BIT
Message-id: <520A43D4.5090606@samsung.com>
Date: Tue, 13 Aug 2013 23:33:56 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120411
 Thunderbird/11.0.1
To: Sangjung Woo <sangjung.woo@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>, linux-kernel@vger.kernel.org,
        Myugnjoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] drivers/rtc/rtc-max77686.c: Fix wrong register
References: <1376401032-31244-1-git-send-email-sangjung.woo@samsung.com>
In-reply-to: <1376401032-31244-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsWyRsSkWPeBM1eQwalOHos569ewWXSefcJs
	cXnXHDaL240r2CwW7ClxYPU4MeM3i0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlrNk3mbFg
	N0fFgx8rWRoYv7N1MXJySAiYSMxqv88CYYtJXLi3HijOxSEksJRRYtmdw6wwRR8232GCSCxi
	lDjXexCsg1dAUOLH5HtANgcHs4C8xJFL2SBhZgF1iUnzFjFD1L9mlNi97ww7RL2WxMWm3WBD
	WQRUJQ7OXQY2h01ATuJt0zdGEFtUIEzi6oTjYHERAW2J+xM+s4AMYhZYwCgxYc4GsISwgLPE
	3mmLwAYJCXhI9LdPZAaxOQU8JbZ8WwO2WUJgG7vEge+n2CC2CUh8m3wI7FIJAVmJTQeYIT6T
	lDi44gbLBEaxWUj+mYXwzywk/yxgZF7FKJpakFxQnJReZKJXnJhbXJqXrpecn7uJERhNp/89
	m7CD8d4B60OMyUAbJzJLiSbnA6MxryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU
	1ILUovii0pzU4kOMTBycUg2MMp/4FqWx33o8od9x6bHUtX1Pzupq8TlHbboyw43NUzgwRSpM
	bL70vatb2p9t4nqyreLI45Ovw/4fvsAuNe2U8NSdMxddmXN1Y/hknbW+NYWqRzu2FZyrN2uR
	D4zonPgxKk2S/57Ywdd5yb8O/X8Xy9zB+dEsQPSvolRK7dGuPduDs9QqjhgGKrEUZyQaajEX
	FScCAJtU07e8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xgO4DZ64gg4M7WCzmrF/DZtF59gmz
	xeVdc9gsbjeuYLNYsKfEgdXjxIzfLB59W1YxenzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjDmLFm32TGgt0cFQ9+rGRpYPzO1sXIySEhYCLxYfMdJghbTOLCvfVA
	cS4OIYFFjBLneg+ygCR4BQQlfky+B2RzcDALyEscuZQNEmYWUJeYNG8RM0T9a0aJ3fvOsEPU
	a0lcbNrNCmKzCKhKHJy7DGwOm4CcxNumb4wgtqhAmMTVCcfB4iIC2hL3J3xmARnELLCAUWLC
	nA1gCWEBZ4m90xaBDRIS8JDob5/IDGJzCnhKbPm2hnkCo8AsJPfNQrhvFpL7FjAyr2IUTS1I
	LihOSs810itOzC0uzUvXS87P3cQIjtVn0jsYVzVYHGIU4GBU4uG1sOMKEmJNLCuuzD3EKMHB
	rCTC+9UGKMSbklhZlVqUH19UmpNafIgxGei7icxSosn5wDSSVxJvaGxiZmRpZG5oYWRsTpqw
	kjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MVixBnxqlfyc5G9pMLfZZbWEU/VGr4uqNs01+
	OWzBB7LLRP2E3Ir0p3GXTpxq8lJ/5XcxL/nex2//7ep1dbD88aDFzH+ifodbTMGOpTN+f+/1
	2qnXMudKgsr6y1HC/TvqPlTbbdly5aGE7Ha5S2I/Y0JuXZvG17hH4h7r/82qYZ5Lw3uWXt6v
	xFKckWioxVxUnAgAbD3THxkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 08월 13일 22:37, Sangjung Woo wrote:

> Fix to read the wrong register when cheching whether the RTC timer has
> reached or not.
> 
> Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
> Signed-off-by: Myugnjoo Ham <myungjoo.ham@samsung.com>
> Reviewed-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> ---
>  drivers/rtc/rtc-max77686.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/rtc/rtc-max77686.c b/drivers/rtc/rtc-max77686.c
> index 9915cb9..a1140c8 100644
> --- a/drivers/rtc/rtc-max77686.c
> +++ b/drivers/rtc/rtc-max77686.c
> @@ -240,7 +240,7 @@ static int max77686_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
>  	}
>  
>  	alrm->pending = 0;
> -	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS1, &val);
> +	ret = regmap_read(info->max77686->regmap, MAX77686_REG_STATUS2, &val);
>  	if (ret < 0) {
>  		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",


Would you change the error message either?

>  				__func__, __LINE__, ret);

Thanks,
Jonghwa.

