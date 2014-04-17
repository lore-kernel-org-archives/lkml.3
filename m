Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaDQRzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 13:55:02 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55468 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaDQRyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 13:54:51 -0400
Date: Thu, 17 Apr 2014 10:54:47 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Peter Tyser <ptyser@xes-inc.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Healy <cphealy@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: lpc_ich: Enable GPIO for Panther Point
Message-ID: <20140417175447.GB18340@roeck-us.net>
References: <1396712974-13853-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396712974-13853-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 05, 2014 at 08:49:34AM -0700, Guenter Roeck wrote:
> Panther Point PCH GPIO configuration is similar to V5 PCHs.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

I don't recall seeing a reply ... ping ...

Thanks,
Guenter

> ---
>  drivers/mfd/lpc_ich.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
> index 37edf9e..d096cca 100644
> --- a/drivers/mfd/lpc_ich.c
> +++ b/drivers/mfd/lpc_ich.c
> @@ -484,6 +484,7 @@ static struct lpc_ich_info lpc_chipset_info[] = {
>  	[LPC_PPT] = {
>  		.name = "Panther Point",
>  		.iTCO_version = 2,
> +		.gpio_version = ICH_V5_GPIO,
>  	},
>  	[LPC_LPT] = {
>  		.name = "Lynx Point",
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
