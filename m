Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984AbaGMJJw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 05:09:52 -0400
Received: from mail.kernel.org ([198.145.19.201]:52209 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbaGMJJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 05:09:44 -0400
Message-ID: <53C24D5E.6070204@kernel.org>
Date: Sun, 13 Jul 2014 10:11:58 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Marcus Folkesson <marcus.folkesson@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
CC: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: adc: ad7192: fix coding style
References: <1405192609-24652-1-git-send-email-marcus.folkesson@gmail.com>
In-Reply-To: <1405192609-24652-1-git-send-email-marcus.folkesson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/14 20:16, Marcus Folkesson wrote:
> Line over 80 characters. This is for Eudyptula Challenge.
>
> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Sorry Marcus,

There is a level of trivial cleanup below which it's not worth
taking patches. The 80 character limit is not a hard and fast
rule. Here, if this had been picked up during review of the original
patch, or was fixed as a part of a more substantial series, I'd
have no objection taking it.  On it's own it's just too small.

Jonathan

> ---
>   drivers/staging/iio/adc/ad7192.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/iio/adc/ad7192.c b/drivers/staging/iio/adc/ad7192.c
> index 83bb44b..c25c9ab 100644
> --- a/drivers/staging/iio/adc/ad7192.c
> +++ b/drivers/staging/iio/adc/ad7192.c
> @@ -223,7 +223,8 @@ static int ad7192_setup(struct ad7192_state *st,
>   	id &= AD7192_ID_MASK;
>
>   	if (id != st->devid)
> -		dev_warn(&st->sd.spi->dev, "device ID query failed (0x%X)\n", id);
> +		dev_warn(&st->sd.spi->dev,
> +			"device ID query failed (0x%X)\n", id);
>
>   	switch (pdata->clock_source_sel) {
>   	case AD7192_CLK_EXT_MCLK1_2:
>

