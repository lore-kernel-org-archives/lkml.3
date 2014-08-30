Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390AbaH3Jpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 05:45:41 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60494 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaH3Jpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 05:45:39 -0400
Message-ID: <54019D42.205@kernel.org>
Date: Sat, 30 Aug 2014 10:45:38 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>
CC: linux-arm-kernel@lists.infradead.org, linux-rockchip@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH] iio: adc: rockchip_saradc: remove unused variable in
 probe
References: <2134722.Yfu4MZ4klm@diego>
In-Reply-To: <2134722.Yfu4MZ4klm@diego>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/08/14 23:40, Heiko Stübner wrote:
> The rate variable in the probe function of the saradc is a remnant
> of a previous patch iteration. It is unused and thus produces a
> compile time warning. Therefore remove it.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Applied to the togreg branch of iio.git - initially pushed out as testing
for the autobuilders to play.

Thanks,

Jonathan
> ---
>  drivers/iio/adc/rockchip_saradc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/rockchip_saradc.c b/drivers/iio/adc/rockchip_saradc.c
> index 1fad964..e074a0b 100644
> --- a/drivers/iio/adc/rockchip_saradc.c
> +++ b/drivers/iio/adc/rockchip_saradc.c
> @@ -141,7 +141,6 @@ static int rockchip_saradc_probe(struct platform_device *pdev)
>  	struct resource	*mem;
>  	int ret;
>  	int irq;
> -	u32 rate;
>  
>  	if (!np)
>  		return -ENODEV;
> 
