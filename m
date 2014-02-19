Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaBSIid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 03:38:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44576 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836AbaBSIic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 03:38:32 -0500
Message-ID: <53046D72.4030002@ti.com>
Date: Wed, 19 Feb 2014 14:08:10 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Mark Brown <broonie@kernel.org>, Keerthy <j-keerthy@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3 v2] regulator: tps65218: Add terminate entry for of_device_id
 table
References: <1392798801.31957.3.camel@phoenix>
In-Reply-To: <1392798801.31957.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 February 2014 02:03 PM, Axel Lin wrote:
> Fixes below build error:
> FATAL: drivers/regulator/tps65218-regulator: struct of_device_id is not terminated with a NULL entry!
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> I'm sorry that I just found I CC wrong developers in my previous mail.
> So here is a resend.
>   drivers/regulator/tps65218-regulator.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
> index 958276c..d1c7831 100644
> --- a/drivers/regulator/tps65218-regulator.c
> +++ b/drivers/regulator/tps65218-regulator.c
> @@ -96,6 +96,7 @@ static const struct of_device_id tps65218_of_match[] = {
>   	TPS65218_OF_MATCH("ti,tps65218-dcdc5", tps65218_pmic_regs[DCDC5]),
>   	TPS65218_OF_MATCH("ti,tps65218-dcdc6", tps65218_pmic_regs[DCDC6]),
>   	TPS65218_OF_MATCH("ti,tps65218-ldo1", tps65218_pmic_regs[LDO1]),
> +	{ }
>   };
>   MODULE_DEVICE_TABLE(of, tps65218_of_match);
Thanks

Acked-by: Keerthy <j-keerthy@ti.com>
>   

