Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbaEMLmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:42:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64136 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610AbaEMLmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:42:44 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-60-537205328017
Message-id: <53720532.8010600@samsung.com>
Date: Tue, 13 May 2014 20:42:42 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/16] mfd: max77693: Make of_device_id array const
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
 <1399978733-13662-15-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1399978733-13662-15-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsWyRsSkRNeItSjY4NdDFYvXLwwt7n89ymhx
	edccNovT3awOLB53ru1h85h3MtCjb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4MjpW3GYqeMNW
	8X7GafYGxjOsXYycHBICJhKH246xQ9hiEhfurWfrYuTiEBJYyigx68NSuKKGqVeYIRKLGCX6
	u+4yQTivGSWOzWllAaniFdCSOHD3NBOIzSKgKrFt+x6wbjag+P4XN9hAbFGBMImV069A1QtK
	/Jh8D8wWETCUOLh7O1gvs0CWxOzjXUBxdg5hAXeJpiSIVW2MEhtm/QEr5xTwlDhytokRolxH
	Yn/rNDYIW15i85q3YIdKCCxjl1izcjMzxD0CEt8mHwJq5gBKyEpsOsAM8ZikxMEVN1gmMIrN
	QnLRLCRjZyEZu4CReRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGYCSd/vdswg7GewesDzEm
	A62cyCwlmpwPjMS8knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUFCQmkJ5akZqemFqQWxReV5qQW
	H2Jk4uCUamDMaNhld3CFYX/TeyHblznHbJrkQ9x5ufykBbKKpr7Lf1U3wT9s5b5aN+c77980
	ypvo7dls1blUpzTsa4bilbNbLfk4T4gpLwxbcEW69/TrLf1VeiV6W2J3S7z9MEvq7Lr9LnEl
	qon+19k/ebue0HztEja7IN4+ujJuxfxZp+edOhDewL5qb6cSS3FGoqEWc1FxIgAp7wNSugIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+xgK4Ra1GwwYOrshavXxha3P96lNHi
	8q45bBanu1kdWDzuXNvD5jHvZKBH35ZVjB6fN8kFsEQ1MNpkpCampBYppOYl56dk5qXbKnkH
	xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dthmhAa4qZrAdMY
	oesbEgTXY2SABhLWMGZ0rLjNVPCGreL9jNPsDYxnWLsYOTkkBEwkGqZeYYawxSQu3FvP1sXI
	xSEksIhRor/rLhOE85pR4ticVhaQKl4BLYkDd08zgdgsAqoS27bvAZvEBhTf/+IGG4gtKhAm
	sXL6Fah6QYkfk++B2SIChhIHd28H62UWyJKYfbwLKM7OISzgLtGUBLGqjVFiw6w/YOWcAp4S
	R842MUKU60jsb53GBmHLS2xe85Z5AqPALCQbZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4Dh9Jr2DcVWDxSFGAQ5GJR7eBc8KgoVYE8uKK3MPMUpwMCuJ8Lp/KgwW4k1J
	rKxKLcqPLyrNSS0+xJgMDICJzFKiyfnAFJJXEm9obGJmZGlkbmhhZGxOmrCSOO/BVutAIYH0
	xJLU7NTUgtQimC1MHJxSDYwFHAIfrsr2iDolJ/qdCpht5+2qeamkes2PTElg2B16+MJV/C5H
	VevJK39Xh5r9nZxiuyWL6Wntd5lDRj0v8n5uDuXhT1Jn/tDs0hyV5jjbv7Wv4demWb2mvRNi
	Fi6ZyaypIMdl75X/Jct9CXvld50XSxdfXc0vnpZ0TG77a4c1z4KvRLUHKrEUZyQaajEXFScC
	AEc7oAUXAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 07:58 PM, Krzysztof Kozlowski wrote:
> Array of struct of_device_id may be be const as expected by
> of_match_table field.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/mfd/max77693.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
> index c5535f018466..7e05428c756d 100644
> --- a/drivers/mfd/max77693.c
> +++ b/drivers/mfd/max77693.c
> @@ -243,7 +243,7 @@ static const struct dev_pm_ops max77693_pm = {
>  };
>  
>  #ifdef CONFIG_OF
> -static struct of_device_id max77693_dt_match[] = {
> +static const struct of_device_id max77693_dt_match[] = {
>  	{ .compatible = "maxim,max77693" },
>  	{},
>  };
> 

Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi
