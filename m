Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaFRP3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:29:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45623 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbaFRP3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:29:52 -0400
Message-ID: <53A1B057.1030902@ti.com>
Date: Wed, 18 Jun 2014 10:29:27 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>, <lgirdwood@gmail.com>, <broonie@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Keerthy <j-keerthy@ti.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH 2/2] regulators: TPS65218: Correct the the config register
 for LDO1
References: <1403104668-32316-1-git-send-email-balbi@ti.com> <1403104668-32316-2-git-send-email-balbi@ti.com>
In-Reply-To: <1403104668-32316-2-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nit pick:
s/regulators: TPS65218:/regulators: tps65218:/

On 06/18/2014 10:17 AM, Felipe Balbi wrote:
> From: Keerthy <j-keerthy@ti.com>
> 
> Correct the the config register for LDO1.
> 
> Cc: <stable@vger.kernel.org> # v3.15
Fixes: 90e7d5262796 (regulator: tps65218: Add Regulator driver for
TPS65218 PMIC)
?

> Signed-off-by: Keerthy <j-keerthy@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/regulator/tps65218-regulator.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/tps65218-regulator.c b/drivers/regulator/tps65218-regulator.c
> index edbc46e..9effe48 100644
> --- a/drivers/regulator/tps65218-regulator.c
> +++ b/drivers/regulator/tps65218-regulator.c
> @@ -209,7 +209,7 @@ static const struct regulator_desc regulators[] = {
>  			   1, -1, -1, TPS65218_REG_ENABLE1,
>  			   TPS65218_ENABLE1_DC6_EN, NULL, NULL, 0, 0),
>  	TPS65218_REGULATOR("LDO1", TPS65218_LDO_1, tps65218_ldo1_dcdc34_ops, 64,
> -			   TPS65218_REG_CONTROL_DCDC4,
> +			   TPS65218_REG_CONTROL_LDO1,
>  			   TPS65218_CONTROL_LDO1_MASK, TPS65218_REG_ENABLE2,
>  			   TPS65218_ENABLE2_LDO1_EN, NULL, ldo1_dcdc3_ranges,
>  			   2, 0),
> 
otherwise,
Acked-by: Nishanth Menon <nm@ti.com>

-- 
Regards,
Nishanth Menon
