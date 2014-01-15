Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaAOK73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:59:29 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:34859 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaAOK72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:59:28 -0500
Message-ID: <52D66A0C.4090509@atmel.com>
Date: Wed, 15 Jan 2014 11:59:24 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Wolfram Sang <wsa@the-dreams.de>
CC: <b.brezillon@overkiz.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] at91: dt: i2c: add a new compatibility string for the
 at91sam9261
References: <1389781467-29626-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1389781467-29626-1-git-send-email-jjhiblot@traphandler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/01/2014 11:24, Jean-Jacques Hiblot :
> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks Jean-Jacques.

Side note: do not forget i2c maintainer and ml.

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
> 


-- 
Nicolas Ferre
