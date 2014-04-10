Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030558AbaDJU0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:26:00 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:61800 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538AbaDJUZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:25:58 -0400
Date: Thu, 10 Apr 2014 16:25:54 -0400
From: Matt Porter <mporter@linaro.org>
To: Tim Kryger <tim.kryger@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: bcm590xx: Set n_voltages for linear reg
Message-ID: <20140410202553.GE23695@beef>
References: <1397160240-2833-1-git-send-email-tim.kryger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397160240-2833-1-git-send-email-tim.kryger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 01:04:00PM -0700, Tim Kryger wrote:
> Fix the macro used to define linear range regulators to include the
> number of voltages.
> 
> Signed-off-by: Tim Kryger <tim.kryger@linaro.org>

Looks good.

Acked-by: Matt Porter <mporter@linaro.org>

Mark: will you take this for 3.15 fixes?

-Matt

> ---
>  drivers/regulator/bcm590xx-regulator.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/regulator/bcm590xx-regulator.c b/drivers/regulator/bcm590xx-regulator.c
> index ab08ca7..c3750c5 100644
> --- a/drivers/regulator/bcm590xx-regulator.c
> +++ b/drivers/regulator/bcm590xx-regulator.c
> @@ -123,6 +123,7 @@ struct bcm590xx_info {
>  #define BCM590XX_REG_RANGES(_name, _ranges) \
>  	{ \
>  		.name = #_name, \
> +		.n_voltages = 64, \
>  		.n_linear_ranges = ARRAY_SIZE(_ranges), \
>  		.linear_ranges = _ranges, \
>  	}
> -- 
> 1.7.9.5
> 
