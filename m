Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaE3BZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:25:24 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:46030 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaE3BZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:25:22 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-6b-5387de01fec5
Message-id: <5387DE01.3000204@samsung.com>
Date: Fri, 30 May 2014 10:25:21 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] extcon: arizona: Remove duplicate set of input parent
 device
References: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-reply-to: <1401377274-10249-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsWyRsSkSJfxXnuwwYkl2hb/ptxgt7i8aw6b
	xe3GFWwWy9/+Z3Ng8Xg58TebR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGVs/nSKveA8e8WF
	l5vYGxjXsXUxcnJICJhIdE47wQhhi0lcuLceKM7FISSwlFFi+vf5zDBFHw48ZoJITGeUuP/2
	DFTVa0aJL82vmUCqeAW0JCZeaWQBsVkEVCUuLJ8MtoINKL7/xQ0wW1QgTGLl9CssEPWCEj8m
	3wOzRQQsJKYsuQW2jVkgUWLOuS/sILawQLjEsZ59rCC2kECoxNcXD8FsTqA593+vYIGo15HY
	3zqNDcKWl9i85i0zyHESAovYJU6/3cYOcZCAxLfJh4AaOIASshKbDkB9JilxcMUNlgmMYrOQ
	nDQLydhZSMYuYGRexSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iREYR6f/PZu4g/H+AetDjMlA
	KycyS4km5wPjMK8k3tDYzMjC1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGH1W2B2afPtIrsiVrx8vZhXpuGpvjNv9z2Hj4uMrDu+Xvay4UeDJEolwv++Tczir
	P5Zta3xx2sSOj/2kje+qR+6M2ta/Pla5eFmzlrFF8LyXZfav/XpwnllVsDf33ExeTcFSjh++
	3GyuEr0+5dXuXtP71jP9SBY5z+My8VV9BN+ynoOtjF1LlViKMxINtZiLihMBzs9DVrkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xoC7jvfZggyvzVCz+TbnBbnF51xw2
	i9uNK9gslr/9z+bA4vFy4m82j74tqxg9Pm+SC2COamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHM2PzpFHvBefaKCy83sTcwrmPrYuTkkBAwkfhw4DEThC0mceHeeqA4F4eQ
	wHRGiftvz0A5rxklvjS/BqviFdCSmHilkQXEZhFQlbiwfDLYJDag+P4XN8BsUYEwiZXTr7BA
	1AtK/Jh8D8wWEbCQmLLkFjOIzSyQKDHn3Bd2EFtYIFziWM8+VhBbSCBU4uuLh2A2J9Cc+79X
	sEDU60jsb53GBmHLS2xe85Z5AqPALCQrZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0
	veT83E2M4Ch9Jr2DcVWDxSFGAQ5GJR7eCentwUKsiWXFlbmHGCU4mJVEeB0PA4V4UxIrq1KL
	8uOLSnNSiw8xJgNDYCKzlGhyPjCB5JXEGxqbmBlZGpkbWhgZm5MmrCTOe7DVOlBIID2xJDU7
	NbUgtQhmCxMHp1QDY8COQI5TcW99qs7ksVhGyFzu/mzot1vlomHD5S28ld6XJdfWVln2h5/j
	C8g98KXs4uo7rq8sd0jVTBDm5/k70/937BOzldnFPtLHTJXm6UjZr+bwLFk9+66Ra+RhyWse
	nTrXfhQrRrb3nlGxb6v5r1HaqL45dqfG2+NlHdaTax8Xl2kV+jEosRRnJBpqMRcVJwIAnr2R
	ShYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 12:27 AM, Charles Keepax wrote:
> devm_input_allocate_device already sets the parent device to be that
> passed to it, we also set this manually in arizona_extcon_probe. This
> patch removes the redundant set from arizona_extcon_probe.
> 
> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/extcon/extcon-arizona.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index cf90743..21ee055 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -1186,7 +1186,6 @@ static int arizona_extcon_probe(struct platform_device *pdev)
>  
>  	info->input->name = "Headset";
>  	info->input->phys = "arizona/extcon";
> -	info->input->dev.parent = &pdev->dev;
>  
>  	if (pdata->num_micd_configs) {
>  		info->micd_modes = pdata->micd_configs;
> 
Applied.

Thanks,
Chanwoo Choi
