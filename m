Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaAOLJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 06:09:03 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:39761 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbaAOLJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:09:00 -0500
Date: Wed, 15 Jan 2014 12:09:01 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
CC: <nicolas.ferre@atmel.com>, <b.brezillon@overkiz.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [PATCH] at91: dt: i2c: add a new compatibility string for the
 at91sam9261
Message-ID: <20140115110901.GQ17817@ldesroches-Latitude-E6320>
Mail-Followup-To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
	nicolas.ferre@atmel.com, b.brezillon@overkiz.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1389781467-29626-1-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1389781467-29626-1-git-send-email-jjhiblot@traphandler.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 11:24:27AM +0100, Jean-Jacques Hiblot wrote:
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

Thanks

> ---
>  drivers/i2c/busses/i2c-at91.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index 8edba9d..843d012 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -589,6 +589,9 @@ static const struct of_device_id atmel_twi_dt_ids[] = {
>  		.compatible = "atmel,at91sam9260-i2c",
>  		.data = &at91sam9260_config,
>  	} , {
> +		.compatible = "atmel,at91sam9261-i2c",
> +		.data = &at91sam9261_config,
> +	} , {
>  		.compatible = "atmel,at91sam9g20-i2c",
>  		.data = &at91sam9g20_config,
>  	} , {
> -- 
> 1.8.5.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
