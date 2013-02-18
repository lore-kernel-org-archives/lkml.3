Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3BRIY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 03:24:28 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:60184 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112Ab3BRIY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 03:24:27 -0500
Message-ID: <5121E535.6040309@slimlogic.co.uk>
Date: Mon, 18 Feb 2013 08:24:21 +0000
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: broonie@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] regulator: palmas: Removing duplicated code
References: <1361164446-3216-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1361164446-3216-1-git-send-email-j-keerthy@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18/02/13 05:14, J Keerthy wrote:
> Removing duplicate assignment in the existing code.
>
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> ---
>  drivers/regulator/palmas-regulator.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index c9e912f..22c6ae2 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -566,11 +566,6 @@ static void palmas_dt_to_pdata(struct device *dev,
>  			pdata->reg_init[idx]->mode_sleep = prop;
>  
>  		ret = of_property_read_u32(palmas_matches[idx].of_node,
> -				"ti,warm_reset", &prop);
> -		if (!ret)
> -			pdata->reg_init[idx]->warm_reset = prop;
> -
> -		ret = of_property_read_u32(palmas_matches[idx].of_node,
>  				"ti,tstep", &prop);
>  		if (!ret)
>  			pdata->reg_init[idx]->tstep = prop;
This hunk has already been upstreamed by Axel Lin.

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=f33d0081ff3ffb7180a9794e60318458d7671b36

Graeme

