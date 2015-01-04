Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbbADCAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 21:00:45 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55738 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbbADCAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 21:00:43 -0500
Date: Sat, 3 Jan 2015 18:00:39 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Nizam Haider <nizamhaider786@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: 0002-Spi-spi-gpio-fixed-spaces-coding-style-issue.patch
Message-ID: <20150104020039.GA15893@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Nizam Haider <nizamhaider786@gmail.com>,
	Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20150103195740.GB20435@suse.suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150103195740.GB20435@suse.suse>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nizam,

You made a lot of mistakes in this patch submission :(

Specifically, you should never include a patch as an attachment [2],
and your subject line should say [PATCH] [2].

If you want to learn how to correctly submit patches I recommend
watching this [1], reading this [2], and signing up for this [3].

  [1]: https://www.youtube.com/watch?v=LLBrBBImJt4

  [2]: https://www.kernel.org/doc/Documentation/SubmittingPatches

  [3]: http://www.eudyptula-challenge.org/

On Sun, Jan 04, 2015 at 01:27:40AM +0530, Nizam Haider wrote:
> 
> From 00454f12a304489125bbdfbc2f50de3c2b9d49d3 Mon Sep 17 00:00:00 2001
> From: Nizam Haider <nizamhaider786@gmail.com>
> Date: Sun, 4 Jan 2015 00:24:38 +0530
> Subject: [PATCH 2/2] Spi: spi-gpio: fixed spaces coding style issue
> 
> Fixed a coding style issue.
> 
> Signed-off-by: Nizam Haider <nizamhaider786@gmail.com>
> ---
>  drivers/spi/spi-gpio.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-gpio.c b/drivers/spi/spi-gpio.c
> index aee4e75..702b0b8 100644
> --- a/drivers/spi/spi-gpio.c
> +++ b/drivers/spi/spi-gpio.c
> @@ -92,7 +92,7 @@ struct spi_gpio {
>  
>  /*----------------------------------------------------------------------*/
>  
> -static inline struct spi_gpio * __pure
> +static inline struct spi_gpio *__pure
>  spi_to_spi_gpio(const struct spi_device *spi)
>  {
>  	const struct spi_bitbang	*bang;
> @@ -103,7 +103,7 @@ spi_to_spi_gpio(const struct spi_device *spi)
>  	return spi_gpio;
>  }
>  
> -static inline struct spi_gpio_platform_data * __pure
> +static inline struct spi_gpio_platform_data *__pure
>  spi_to_pdata(const struct spi_device *spi)
>  {
>  	return &spi_to_spi_gpio(spi)->pdata;
> -- 
> 1.8.1.4
> 


-- 
- Jeremiah Mahler
