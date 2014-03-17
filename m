Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932201AbaCQBFz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 21:05:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47941 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812AbaCQBFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 21:05:53 -0400
X-AuditID: cbfee68f-b7f156d00000276c-7d-53264a70daf3
Message-id: <53264E61.2010502@samsung.com>
Date: Mon, 17 Mar 2014 10:22:41 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: t.figa@samsung.com, mturquette@linaro.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clk: samsung: fixed compiler warning
 [-Wpointer-to-int-cast]
References: <1393382561-5388-1-git-send-email-pankaj.dubey@samsung.com>
In-reply-to: <1393382561-5388-1-git-send-email-pankaj.dubey@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t8zI90CL7Vgg00b1Cw2Pb7GanF51xw2
	ixnn9zFZPJ1wkc1i0dYv7BbrZ7xmcWDzuHNtD5vH5iX1Hn1bVjF6fN4kF8ASxWWTkpqTWZZa
	pG+XwJXx9/QcxoL5HBUtu18xNjC+Yeti5OCQEDCReHEjtouRE8gUk7hwbz1QmItDSGAZo0Tr
	2ZdMEAkTiY9zehkhEosYJa6dOc0E4bxmlNhx+CQLSBWvgJbE90lnwGwWAVWJd8eesoLYbAK6
	Ek/ez2UGsUUFwiQ2Te9jhagXlPgx+R5YvYiAtkTn5XusIEOZBWYwSrxdd40RJCEsECzRvLMD
	7AwhAXeJnpnfwOKcAh4SE65uBrOZBawlVk7aBmXLS2xe85YZZJCEwD52iduNy5ghLhKQ+Db5
	EAvEz7ISmw4wQ7wmKXFwxQ2WCYxis5DcNAvJ2FlIxi5gZF7FKJpakFxQnJReZKxXnJhbXJqX
	rpecn7uJERJj/TsY7x6wPsSYDLRyIrOUaHI+MEbzSuINjc2MLExNTI2NzC3NSBNWEue9/zAp
	SEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjkkykp4DGzej8n9P7JHV2H5un9kDqYuPxuDO/
	gtsXm1We+9rmXfVA16+rK9fyanet3pSZZ0MnzPx8qTO8vv66xNnJrolNbDtCmv7K+HD++Pf3
	/uyOds1NBQ1XJnrOn/FW6Mg16zsFZdKhKYul5344W/z/fOQXlwxFg5YZi9MmG544Ozc/yMdb
	iaU4I9FQi7moOBEAodft6ccCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAd0CL7Vgg9nPlSw2Pb7GanF51xw2
	ixnn9zFZPJ1wkc1i0dYv7BbrZ7xmcWDzuHNtD5vH5iX1Hn1bVjF6fN4kF8AS1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8ff0HMaC+RwVLbtfMTYwvmHrYuTkkBAwkfg4
	p5cRwhaTuHBvPVCci0NIYBGjxLUzp5kgnNeMEjsOn2QBqeIV0JL4PukMmM0ioCrx7thTVhCb
	TUBX4sn7ucwgtqhAmMSm6X2sEPWCEj8m3wOrFxHQlui8fI8VZCizwAxGibfrroGtFhYIlmje
	2cEEYgsJuEv0zPwGFucU8JCYcHUzmM0sYC2xctI2KFteYvOat8wTGAVmIdkxC0nZLCRlCxiZ
	VzGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/Az6R2MqxosDjEKcDAq8fBOUFYLFmJNLCuu
	zD3EKMHBrCTCm2AOFOJNSaysSi3Kjy8qzUktPsSYDAyCicxSosn5wPSSVxJvaGxiZmRpZGZh
	ZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MK2SNSnrOxB7z+8Wsfd5f5vVDdtV6
	rWvuyj0mMW8CZyfOrCvS0bgZ+T2cc7dqTNXy3wpP77s9WvC+/cLEfInC3Ka5jquZhPy6SiVu
	ZghcUv4iq/nqgHH9BKWk0z8uxN2vF+cQW/zER2iWzf8tH1dLnI05vkzlW92ED8e2f9cquBPv
	k97N4nJSiaU4I9FQi7moOBEAy3sw1SUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 11:42 AM, Pankaj Dubey wrote:
> When compiled using ARM64 cross compiler, gcc complains as
>
> drivers/clk/samsung/clk.c:293:18:
> warning: cast from pointer to integer of different size
> [-Wpointer-to-int-cast]
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> ---
>   drivers/clk/samsung/clk.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clk/samsung/clk.c b/drivers/clk/samsung/clk.c
> index 91bec3e..59142ba 100644
> --- a/drivers/clk/samsung/clk.c
> +++ b/drivers/clk/samsung/clk.c
> @@ -278,7 +278,7 @@ void __init samsung_clk_of_register_fixed_ext(
>   	for_each_matching_node_and_match(np, clk_matches, &match) {
>   		if (of_property_read_u32(np, "clock-frequency", &freq))
>   			continue;
> -		fixed_rate_clk[(u32)match->data].fixed_rate = freq;
> +		fixed_rate_clk[(unsigned long)match->data].fixed_rate = freq;
>   	}
>   	samsung_clk_register_fixed_rate(fixed_rate_clk, nr_fixed_rate_clk);
>   }

Gentle Ping.

-- 
Best Regards,
Pankaj Dubey

