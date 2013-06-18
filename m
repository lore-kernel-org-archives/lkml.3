Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab3FRQ5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:57:21 -0400
Received: from shell.v3.sk ([195.168.3.45]:53049 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933077Ab3FRQ5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:57:19 -0400
Subject: Re: [PATCH] hwrng: bcm2835: fix MODULE_LICENSE tag
From: Lubomir Rintel <lkundrak@v3.sk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dom Cobley <popcornmix@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Matt Mackall <mpm@selenic.com>,
        linux-rpi-kernel@lists.infradead.org,
        Herbert Xu <herbert@gondor.hengli.com.au>
In-Reply-To: <1366732475-479886-4-git-send-email-arnd@arndb.de>
References: <1366732475-479886-1-git-send-email-arnd@arndb.de>
	 <1366732475-479886-4-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Jun 2013 18:57:13 +0200
Message-ID: <1371574633.18688.9.camel@hobbes.kokotovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-23 at 17:54 +0200, Arnd Bergmann wrote:
> The MODULE_LICENSE macro invocation must use either "GPL" or "GPL v2",
> but not "GPLv2" in order to be detected by the module loader.
> 
> This fixes the allmodconfig build error:
> 
> FATAL: modpost: GPL-incompatible module bcm2835-rng.ko uses GPL-only symbol 'platform_driver_unregister'

Thank you, obviously a typo of mine that slipped through. I'm wondering
if this could get queued for 3.10; it definitely can't do any harm.

Acked-by: Lubomir Rintel <lkundrak@v3.sk>

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


