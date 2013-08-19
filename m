Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab3HSIcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 04:32:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:59198 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3HSIcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 04:32:53 -0400
X-AuditID: cbfee691-b7fef6d000002d62-9c-5211d834b2e6
Message-id: <5211D834.4010704@samsung.com>
Date: Mon, 19 Aug 2013 17:32:52 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, broonie@kernel.org,
        patches@linaro.org
Subject: Re: [PATCH 1/1] extcon: arizona: Fix a typo in a comment
References: <1375693246-28350-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1375693246-28350-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsWyRsSkWNfkhmCQwe3T0hZTHz5hs7i8aw6b
	xe3GFWwWUw5/YbE4+aeX0YHVY9OqTjaPO9f2sHn0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJX
	xpQ9nxgLfrNVNO3awdjAeIK1i5GDQ0LAROLFXbEuRk4gU0ziwr31bF2MXBxCAksZJR69ecwE
	kTCRWPnoBiNEYhGjxNUjB5ggnFeMEj1PN7KDVPEKaElM/DafGcRmEVCV2Hl3DyOIzQYU3//i
	BhuILSoQJrFy+hUWiHpBiR+T74HZIkA1L7uXg21jFkiROPFpLthMYQFHieVv74DVCAm4Sxzd
	MgGshlPAQ+JE4xt2iHodif2t09ggbHmJzWveMoMcJyGwjV2iZ+kdRoiDBCS+TT7EAvGyrMSm
	A8wQn0lKHFxxg2UCo9gsJCfNQjJ2FpKxCxiZVzGKphYkFxQnpReZ6hUn5haX5qXrJefnbmIE
	Rtbpf88m7mC8f8D6EGMy0MqJzFKiyfnAyMwriTc0NjOyMDUxNTYytzQjTVhJnFe9xTpQSCA9
	sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6Mgl+rnHtfN+2fZezuxOsxIfDT5tfDLjl5jXbXGjZGq
	7xM4C86sOtT2btZeQS+R+juJLB/nrY3+e3OV+dNlGZGO/Z4XL6/r6fz54c+kBj1/TU2h1V5V
	pjZzlBas2LftQKlx17nnuyS8PAQ6eGx3VL7bKVP74uHXgMvWXgZvGYuPLFLsi+D9+FmJpTgj
	0VCLuag4EQB5QhpFwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgK7JDcEgg4nNYhZTHz5hs7i8aw6b
	xe3GFWwWUw5/YbE4+aeX0YHVY9OqTjaPO9f2sHn0bVnF6PF5k1wAS1QDo01GamJKapFCal5y
	fkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0GIlhbLEnFKgUEBicbGSvh2m
	CaEhbroWMI0Rur4hQXA9RgZoIGENY8aUPZ8YC36zVTTt2sHYwHiCtYuRk0NCwERi5aMbjBC2
	mMSFe+vZuhi5OIQEFjFKXD1ygAnCecUo0fN0IztIFa+AlsTEb/OZQWwWAVWJnXf3gHWzAcX3
	v7jBBmKLCoRJrJx+hQWiXlDix+R7YLYIUM3L7uVMIDazQIrEiU9zwWYKCzhKLH97B6xGSMBd
	4uiWCWA1nAIeEica37BD1OtI7G+dxgZhy0tsXvOWeQKjwCwkK2YhKZuFpGwBI/MqRtHUguSC
	4qT0XCO94sTc4tK8dL3k/NxNjODIfSa9g3FVg8UhRgEORiUeXgs3wSAh1sSy4srcQ4wSHMxK
	IrwsakAh3pTEyqrUovz4otKc1OJDjMnAEJjILCWanA9MKnkl8YbGJmZGlkbmhhZGxuakCSuJ
	8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwBhRKqJVfnnWtIVdrw9Yz2s6zWHsfu+qlhzzwpNK
	BYvbNXMuebfP+H84PsRBX62OYdaUlJPMi1axnmvYG5y15fBsj89Oj6KO/PxRMmfr7KO/z96f
	YMx8YtYG2TOnHx42fMr5I8vRP+x9/QPGBwH1QQ+FTh1uLlp56rv3B5WrjxmrNGp0NYQlNXmU
	WIozEg21mIuKEwF2CVO9IAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2013 06:00 PM, Sachin Kamat wrote:
> Fixes an incomplete comment introduced by commit 9c2ba270
> ("extcon: arizona: Simplify HPDET based identification").
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/extcon/extcon-arizona.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/extcon/extcon-arizona.c b/drivers/extcon/extcon-arizona.c
> index e557130..5061ae5 100644
> --- a/drivers/extcon/extcon-arizona.c
> +++ b/drivers/extcon/extcon-arizona.c
> @@ -514,7 +514,7 @@ static int arizona_hpdet_do_id(struct arizona_extcon_info *info, int *reading,
>  		}
>  
>  		/*
> -		 * If we measure the mic as 
> +		 * If we measure the mic as high impedance
>  		 */
>  		if (!id_gpio || info->hpdet_res[1] > 50) {
>  			dev_dbg(arizona->dev, "Detected mic\n");
> 

Applied it.

Thanks,
Chanwoo Choi
