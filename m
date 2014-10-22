Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753671AbaJVEV2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 00:21:28 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:51735 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaJVEV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 00:21:26 -0400
Date: Wed, 22 Oct 2014 09:51:15 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Brian Vandre <bvandre@gmail.com>
Cc: gregkh@linuxfoundation.org, jic23@kernel.org,
        alexandre.belloni@free-electrons.com, linux-iio@vger.kernel.org,
        marex@denx.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: iio: adc: fix line over 80 characters
Message-ID: <20141022042115.GA2530@sudip-PC>
References: <cover.1413858979.git.bvandre@gmail.com>
 <cover.1413931615.git.bvandre@gmail.com>
 <ec4b497827f6c7615f6b5eef5669144f8c68d034.1413931615.git.bvandre@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec4b497827f6c7615f6b5eef5669144f8c68d034.1413931615.git.bvandre@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 05:56:47PM -0500, Brian Vandre wrote:
> This fixes the 2 checkpatch.pl warnings:
> WARNING: line over 80 characters
> 
please check your patch with --strict option of checkpatch.pl , and you will get :
"Alignment should match open parenthesis" .

thanks
sudip

> Signed-off-by: Brian Vandre <bvandre@gmail.com>
> ---
>  drivers/staging/iio/adc/mxs-lradc.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
> index 32a1926..62449a6 100644
> --- a/drivers/staging/iio/adc/mxs-lradc.c
> +++ b/drivers/staging/iio/adc/mxs-lradc.c
> @@ -455,7 +455,8 @@ static void mxs_lradc_setup_ts_channel(struct mxs_lradc *lradc, unsigned ch)
>  	 * SoC's delay unit and start the conversion later
>  	 * and automatically.
>  	 */
> -	mxs_lradc_reg_wrt(lradc, LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
> +	mxs_lradc_reg_wrt(lradc,
> +		LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
>  		LRADC_DELAY_TRIGGER_DELAYS(1 << 3) | /* trigger DELAY unit#3 */
>  		LRADC_DELAY_KICK |
>  		LRADC_DELAY_DELAY(lradc->settling_delay),
> @@ -513,7 +514,8 @@ static void mxs_lradc_setup_ts_pressure(struct mxs_lradc *lradc, unsigned ch1,
>  	 * SoC's delay unit and start the conversion later
>  	 * and automatically.
>  	 */
> -	mxs_lradc_reg_wrt(lradc, LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
> +	mxs_lradc_reg_wrt(lradc,
> +		LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
>  		LRADC_DELAY_TRIGGER_DELAYS(1 << 3) | /* trigger DELAY unit#3 */
>  		LRADC_DELAY_KICK |
>  		LRADC_DELAY_DELAY(lradc->settling_delay), LRADC_DELAY(2));
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
