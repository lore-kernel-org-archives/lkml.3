Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab3JNScT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:32:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46641 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750843Ab3JNScS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:32:18 -0400
Message-ID: <525C38AB.3060002@ti.com>
Date: Mon, 14 Oct 2013 13:32:11 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>, "'Mark Brown'" <broonie@linaro.org>
CC: "'Liam Girdwood'" <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>,
        "'Balaji T K'" <balajitk@ti.com>
Subject: Re: [PATCH 11/11] regulator: twl: Fix checkpatch issue
References: <000001cec8b9$931f4c90$b95de5b0$%han@samsung.com> <000a01cec8bb$13bf5970$3b3e0c50$%han@samsung.com>
In-Reply-To: <000a01cec8bb$13bf5970$3b3e0c50$%han@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 03:55 AM, Jingoo Han wrote:
> Fix the following checkpatch warnings.
> 
>   WARNING: please, no space before tabs
>   WARNING: space prohibited between function name and open parenthesis '('
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/regulator/twl-regulator.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
> index 8ebd785..fed28ab 100644
> --- a/drivers/regulator/twl-regulator.c
> +++ b/drivers/regulator/twl-regulator.c
> @@ -58,7 +58,7 @@ struct twlreg_info {
>  	struct regulator_desc	desc;
>  
>  	/* chip specific features */
> -	unsigned long 		features;
> +	unsigned long		features;
>  
>  	/*
>  	 * optional override functions for voltage set/get
> @@ -1128,7 +1128,7 @@ static int twlreg_probe(struct platform_device *pdev)
>  	if (!initdata)
>  		return -EINVAL;
>  
> -	info = kmemdup(template, sizeof (*info), GFP_KERNEL);
> +	info = kmemdup(template, sizeof(*info), GFP_KERNEL);
>  	if (!info)
>  		return -ENOMEM;
>  
> 

Acked-by: Nishanth Menon <nm@ti.com>
-- 
Regards,
Nishanth Menon
