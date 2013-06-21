Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786Ab3FUHQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:16:52 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:55460 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758770Ab3FUHQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:16:51 -0400
Date: Fri, 21 Jun 2013 15:16:03 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org,
        Dom Cobley <popcornmix@gmail.com>, Lubomir Rintel <lkundrak@v3.sk>,
        Stephen Warren <swarren@wwwdotorg.org>, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org
Subject: Re: [PATCH 05/15] hwrng: bcm2835: fix MODULE_LICENSE tag
Message-ID: <20130621071603.GA24151@gondor.apana.org.au>
References: <1370038972-2318779-1-git-send-email-arnd@arndb.de>
 <1370038972-2318779-6-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370038972-2318779-6-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 01, 2013 at 12:22:42AM +0200, Arnd Bergmann wrote:
> The MODULE_LICENSE macro invocation must use either "GPL" or "GPL v2",
> but not "GPLv2" in order to be detected by the module loader.
> 
> This fixes the allmodconfig build error:
> 
> FATAL: modpost: GPL-incompatible module bcm2835-rng.ko uses GPL-only symbol 'platform_driver_unregister'
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Dom Cobley <popcornmix@gmail.com>
> Cc: Lubomir Rintel <lkundrak@v3.sk>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  drivers/char/hw_random/bcm2835-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
> index eb7f147..43577ca 100644
> --- a/drivers/char/hw_random/bcm2835-rng.c
> +++ b/drivers/char/hw_random/bcm2835-rng.c
> @@ -110,4 +110,4 @@ module_platform_driver(bcm2835_rng_driver);
>  
>  MODULE_AUTHOR("Lubomir Rintel <lkundrak@v3.sk>");
>  MODULE_DESCRIPTION("BCM2835 Random Number Generator (RNG) driver");
> -MODULE_LICENSE("GPLv2");
> +MODULE_LICENSE("GPL v2");

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
